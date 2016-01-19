require 'socket'
require 'thread'

STUDENT_ID = "049fab2b9ed8146e9994a921f654febcdd3cd31c28b62db0020a0bbd889ff3f4"
service_kill = false

unless ARGV.length == 1
	print "The correct number of arguments is 1!\n"
	exit
end

port = ARGV[0]
puts "Servers started on port #{port}"
server = TCPServer.new port
client_queue = Queue.new

Thread.new do
	loop do
		Thread.start(server.accept) do |client|
			puts "client connected"
			client_queue.push(client)
		end
	end
end

workers = (0...2).map do
	Thread.new do
		begin
			while client = client_queue.pop()
				input = client.gets
				if (/HELO \w/).match(input) != nil
					client.puts "#{input}\nIP:#{client.addr[2]}\nPort:#{port}\nStudentID:#{STUDENT_ID}\n"
				elsif input == "KILL SERVICE\n"
					service_kill = true
				else
					client.puts "else: " + input
				end
				client.close
			end
		end
	end
end

while !service_kill
end
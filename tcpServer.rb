require 'socket'
require 'thread'


server = TCPServer.new 2000
activeQ = Queue.new

loop do
	Thread.start(server.accept) do |client| 
    print client.gets
    activeQ.push(client)
    loop do
      workers = (0...2).map do  
        Thread.new do
          begin
            if activeQ.empty?
              print "Sleeping #{Thread.current}\n"
              sleep(1)
            else
              while !activeQ.empty?
                var = activeQ.pop()
                var.puts "Hello !"
                var.puts "Time is #{Time.now}"
                sleep(4)
                print "Disconnecting Client\n"
                var.puts "Disconnected"
                var.close
              end
            end
          end
        end
      end
    workers.map(&:join)
    end
  end
end






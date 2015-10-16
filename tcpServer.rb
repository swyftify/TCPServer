require 'socket'
require 'thread'

unless ARGV.length == 1
  print "The correct number of arguments is 1!\n"
  exit
end

port = ARGV[0]
puts "Servers started on port #{port}"

server = TCPServer.new port
activeQ = Queue.new
lock = Mutex.new

threadNum = 0
killSwitch = false

Thread.new do
  loop do
    Thread.start(server.accept) do |client|
      activeQ.push(client)
    end
  end  
end

Thread.new do
  loop do
    if !activeQ.empty? and threadNum < 3
      Thread.new do
        threadNum+=1
        client = activeQ.pop()
        client.puts("#{Time.now}")
        puts "#{threadNum}"
        puts "Client active"
        clientRunning = true
        while clientRunning
          input = client.gets
          puts input
          if input.start_with?("HELO")
            puts input
            helo, text = input.split(" ",2)
            puts "#{text}"
            client.puts "HELO #{text}"
          elsif input == "KILl_SERVICE\n"
            client.puts "KILL"
            killSwitch = true
            clientRunning = false       
          end
        end
        if killSwitch == true
          exit
        end
        threadNum -=1
        client.close
      end
    else
      sleep(1)  
    end  
  end 
end

while true

end





=begin
  
workers = (0...2).map do  
  Thread.start(server.accept) do |client|
    print client.gets
    input = client.gets
    client.puts "Hello !"
    client.puts "Time is #{Time.now}"
    clientRunning = true;
    while clientRunning
      if input.start_with?("HELO")
        client.puts "Hello"
      elsif input == "KIL"
        client.puts "KILL"
        clientRunning = false
      else
        puts input    
      end
    end
  end
end
workers.map(&:join)

=end






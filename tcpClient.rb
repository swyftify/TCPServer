require 'socket'

port = 2000
host = 'localhost'

socket = TCPSocket.open(host,port)
puts socket.gets
input = gets.chomp
while input != "end"
	socket.puts(input)
	print "SERVER SAID\n"
	puts socket.gets
	input = gets.chomp
	socket.puts(input)
end
puts "Disconnected"
socket.close
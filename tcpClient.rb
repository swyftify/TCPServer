require 'socket'

port = 2000
host = 'localhost'

socket = TCPSocket.open(host,port)
socket.puts "Connected"
while line = socket.gets
	puts line.chop
end
socket.close
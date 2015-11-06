require 'socket'

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname,port)

while line = s.gets  # Reads lines from the socket
  puts line.chop
end
s.close
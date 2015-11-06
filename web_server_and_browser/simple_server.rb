# Get sockets from stdlib
require 'socket'
require 'json'

server = TCPServer.open(2000)   # Socket to listen on port 200
loop do
  client = server.accept        # Wait for a client to connect
  request = client.gets
  method,path,version = request.split(" ")
  if method == "GET"
    if File.exist?(path)
      client.puts(version + " 200 OK")
      client.puts("Date: " + Time.now.ctime)
      client.puts("Content Length: " + File.open(path).size.to_s + "\r\n\r\n")
      client.puts(File.open(path).readlines.each { |line| puts line })
    else
      client.puts(version + " 404 Not Found")
    end
  elsif method == "POST"
    params = {}
    params << JSON.parse(path)
    thanks_file = "web_server_and_browser/thanks_viking.html"
    client.puts(version + " 200 OK")
    client.puts("Date: " + Time.now.ctime)
    client.puts("Content Length: " + File.open(thanks_file).size.to_s + "\r\n\r\n")
    client.puts(File.open(thanks_file).readlines.each { |line| puts line })
  end
  client.puts "Closing the connection. Bye!"
  client.close
end
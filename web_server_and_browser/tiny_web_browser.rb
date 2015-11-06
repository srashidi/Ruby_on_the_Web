require 'socket'
require 'json'

host = 'localhost'          # The web server
port = 2000                 # Default HTTP port is 80, and local is 2000
path = "web_server_and_browser/thanks.html"        # The file we want

# Asks for input of type of request
printf "What type of request would you like to send, \"GET\" or \"POST\"? "
request_type = gets.chomp.strip.upcase
case request_type
when "GET"
  request = "GET #{path} HTTP/1.0\r\n\r\n"  # HTTP request sent to fetch a file
when "POST"
  puts "You are a viking registering for the upcoming raid."
  printf "What is your name? "
  name = gets.chomp.strip
  printf "What is your email? "
  email = gets.chomp.strip
  results = {viking: {name: name, email: email} }
  request = "POST #{results.to_json} HTTP/1.0\nContent-Length: results.size\r\n\r\n"
else
  puts "Invalid input!"
end

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2)
initial_response_line = headers.split("\n")[0]
version,response_status = initial_response_line.split(" ")
reason = initial_response_line.split(" ")[2..-1].join(" ")
if response_status == "200"
  print body                        # Display body
else
  print response_status + " " + reason
end
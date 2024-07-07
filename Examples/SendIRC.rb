require 'socket'

UNIX_SOCKET_PATH = '/tmp/irc_bot_socket'

def main
  message = "PRIVMSG #example_channel :Hello from external script!\n"

  client_socket = UNIXSocket.new(UNIX_SOCKET_PATH)

  begin
    client_socket.write(message)
    puts "Sent message to IRC bot: #{message.strip}"
  rescue => e
    puts "Error sending message: #{e.message}"
  ensure
    client_socket.close if client_socket
  end
end

if __FILE__ == $0
  main
end

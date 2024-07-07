import socket

unix_socket_path_input = "/tmp/irc_bot_socket"

def main():
    message = "PRIVMSG #example_channel :Hello from external script!"

    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client_socket.connect(unix_socket_path_input)

    try:
        client_socket.sendall(message.encode())
        print(f"Sent message to IRC bot: {message}")
    except Exception as e:
        print(f"Error sending message: {str(e)}")
    finally:
        client_socket.close()

if __name__ == "__main__":
    main()

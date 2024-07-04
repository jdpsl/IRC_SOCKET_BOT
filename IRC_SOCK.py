import socket
import os
import time
from multiprocessing import Process

server = "irc.freenode.net"  # Example IRC server
channel = "#example_channel"  # Channel to join
botnick = "SimpleIRCBot"  # Bot's nickname
unix_socket_path = "/tmp/irc_bot_socket"  # Path to the Unix socket

def irc_connect():
    irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print("Connecting to:", server)
    irc.connect((server, 6667))
    irc_send(irc, f"USER {botnick} {botnick} {botnick} :This is a simple bot")
    irc_send(irc, f"NICK {botnick}")
    irc_send(irc, f"JOIN {channel}")
    return irc

def irc_send(irc, msg):
    irc.send(f"{msg}\r\n".encode())

def handle_unix_socket(irc):
    if os.path.exists(unix_socket_path):
        os.remove(unix_socket_path)

    server_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server_socket.bind(unix_socket_path)
    server_socket.listen(1)
    print(f"Unix socket listening at {unix_socket_path}")

    while True:
        conn, _ = server_socket.accept()
        with conn:
            data = conn.recv(1024)
            if data:
                command = data.decode().strip()
                if command:
                    irc_send(irc, command)

def main():
    irc = irc_connect()

    process = Process(target=handle_unix_socket, args=(irc,))
    process.start()

    try:
        while True:
            msg = irc.recv(2048).decode()
            msg = msg.strip('\n\r')
            print(msg)

            if msg.startswith("PING"):
                irc_send(irc, f"PONG {msg.split()[1]}")
                print(f"PONG {msg.split()[1]}")

            if "VERSION" in msg and "PRIVMSG" in msg:
                user = msg.split('!')[0][1:]
                irc_send(irc, f"NOTICE {user} :\x01VERSION SimpleIRCBot v1.0\x01")
                print(f"NOTICE {user} :\x01VERSION SimpleIRCBot v1.0\x01")

    except KeyboardInterrupt:
        print("Bot is shutting down.")
    except Exception as e:
        print("Error:", str(e))
    finally:
        irc_send(irc, "QUIT :Bye!")
        irc.close()
        process.terminate()
        if os.path.exists(unix_socket_path):
            os.remove(unix_socket_path)

if __name__ == "__main__":
    main()

#!/usr/local/bin/python3

import socket
import os
import time
import glob
from multiprocessing import Process

server = "IRC.HOSTNAME"  # Example IRC server
channel = "#Your Channel"  # Channel to join
botnick = "OoboT"  # Bot's nickname
unix_socket_path = "/tmp/irc_bot_socket"  # Path to the Unix socket
script_dir = "./scripts"  # Directory containing scripts

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

def execute_scripts(irc, message, channel, user):
    scripts = [f for f in os.listdir(script_dir) if os.path.isfile(os.path.join(script_dir, f)) and os.access(os.path.join(script_dir, f), os.X_OK) and not f.startswith('.')]

    for script_name in scripts:
        script_path = os.path.join(script_dir, script_name)
        command = f"{script_path} \"{message}\" \"{channel}\" \"{user}\" \"{botnick}\""
        try:
            script_output = os.popen(command).read().strip()
            if script_output:
                irc_send(irc, f"PRIVMSG {channel} :{script_output}")
                print(f"Executed {script_name}: {script_output}")
        except Exception as e:
            print(f"Error executing {script_name}: {str(e)}")

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

            if "PRIVMSG" in msg:
                user = msg.split('!')[0][1:]
                channel = msg.split()[2]
                message = ' '.join(msg.split()[3:])[1:]

                execute_scripts(irc, message, channel, user)

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

#!/bin/bash

unix_socket_path="/tmp/irc_bot_socket"
message="PRIVMSG #example_channel :Hello from external script!"

main() {
    if [ ! -S "$unix_socket_path" ]; then
        echo "Error: Unix socket $unix_socket_path does not exist or is not a socket."
        exit 1
    fi

    # Use socat to connect to the Unix domain socket and send the message
    echo "$message" | socat - UNIX-CONNECT:"$unix_socket_path"
    echo "Sent message to IRC bot: $message"
}

main

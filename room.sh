#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <server> <botnick> <room/nick>"
    exit 1
fi

# Capture the arguments
SERVER="$1"
BOTNICK="$2"
ROOM_NICK="$3"

# Create the socket variable
theSocket="/tmp/irc_bot_socket_${SERVER}_${BOTNICK}"

# Check if the socket file exists
if [ ! -S "$theSocket" ]; then
    echo "Error: Socket file $theSocket does not exist."
    exit 1
fi

# Join the room
echo "JOIN $ROOM_NICK" | socat - UNIX-CONNECT:$theSocket

# Infinite loop to wait for user input
while true; do
    read -p "$ROOM_NICK: " INPUT

    # Check if input is empty
    if [ -z "$INPUT" ]; then
        continue
    fi

    # Prepare IRC PRIVMSG command
    PRIVMSG="PRIVMSG $ROOM_NICK :$INPUT"

    # Output the IRC PRIVMSG command (you would normally send it through your IRC socket here)
    echo $PRIVMSG | socat - UNIX-CONNECT:$theSocket
done

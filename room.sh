#!/bin/bash

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <room/nick>"
    exit 1
fi

# Capture room/nick argument
ROOM_NICK="$1"


# Join the room
echo "JOIN $ROOM_NICK"| socat - UNIX-CONNECT:/tmp/irc_bot_socket

# Infinite loop to wait for user input
while true; do
    read -p "$ROOM_NICK: " INPUT

    # Check if input is empty
    if [ -z "$INPUT" ]; then
        continue
    fi

    # Prepare IRC PRIVMSG command
    PRIVMSG="PRIVMSG $ROOM_NICK :$INPUT"

    # Send the command over socat
    echo $PRIVMSG| socat - UNIX-CONNECT:/tmp/irc_bot_socket

done

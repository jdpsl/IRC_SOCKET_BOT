#!/bin/bash

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <room/nick> <key>"
    exit 1
fi

# Capture room/nick and key arguments
ROOM_NICK="$1"
KEY="$2"

# Function to encrypt a message using AES with OpenSSL
encrypt_message() {
    local message="$1"
    echo "$message" | openssl enc -e -aes-256-cbc -base64 -pbkdf2 -pass pass:"$KEY"
}

# Join the room
echo "JOIN $ROOM_NICK" | socat - UNIX-CONNECT:/tmp/irc_bot_socket

# Infinite loop to wait for user input
while true; do
    read -p "$ROOM_NICK: " INPUT

    # Check if input is empty
    if [ -z "$INPUT" ]; then
        continue
    fi

    # Encrypt the input message
    ENCRYPTED_MESSAGE=$(encrypt_message "$INPUT")

    # Prepare IRC PRIVMSG command with the encrypted message
    PRIVMSG="PRIVMSG $ROOM_NICK :!enc $ENCRYPTED_MESSAGE"

    # Output the IRC PRIVMSG command (you would normally send it through your IRC socket here)
    echo $PRIVMSG | socat - UNIX-CONNECT:/tmp/irc_bot_socket

done

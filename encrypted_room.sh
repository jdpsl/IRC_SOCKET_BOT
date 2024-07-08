#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <server> <botnick> <room/nick> <key>"
    exit 1
fi

# Capture the arguments
SERVER="$1"
BOTNICK="$2"
ROOM_NICK="$3"
KEY="$4"


# Create the socket variable
theSocket="/tmp/irc_bot_socket_${SERVER}_${BOTNICK}"

# Check if the socket file exists
if [ ! -S "$theSocket" ]; then
    echo "Error: Socket file $theSocket does not exist."
    exit 1
fi


# Function to encrypt a message using AES with OpenSSL
encrypt_message() {
    local message="$1"
    echo "$message" | openssl enc -e -aes-256-cbc -base64 -pbkdf2 -pass pass:"$KEY"
}

# Join the room
echo "JOIN $ROOM_NICK" | socat - UNIX-CONNECT:$theSocket

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
    echo $PRIVMSG | socat - UNIX-CONNECT:$theSocket

done

#!/bin/bash

# ASCII art header
echo " _____ _____   _____    _____  ____   _____ _  ________ _______ "
echo "|_   _|  __ \ / ____|  / ____|/ __ \ / ____| |/ /  ____|__   __|"
echo "  | | | |__) | |      | (___ | |  | | |    | ' /| |__     | |   "
echo "  | | |  _  /| |       \___ \| |  | | |    |  < |  __|    | |   "
echo " _| |_| | \ \| |____   ____) | |__| | |____| . \| |____   | |   "
echo "|_____|_|  \_\\_____| |_____/ \____/ \_____|_|\_\______|  |_|   "
echo "                   ______                                        "
echo "                  |______| Console                               "
echo ""

# Array to store server and botnick combinations
declare -a server_botnick_array=()

# List all files matching /tmp/irc_bot_socket_*
echo "Listing all Active IRC Bots"
index=1
for file in /tmp/irc_bot_socket_*; do
    # Extract basename and remove "irc_bot_socket_"
    filename=$(basename "$file")
    trimmed_filename=${filename#irc_bot_socket_}

    # Parse server and botnick
    server=$(echo "$trimmed_filename" | cut -d'_' -f1)
    botnick=$(echo "$trimmed_filename" | cut -d'_' -f2)

    # Store in array
    server_botnick_array+=("$server"$'\t'"$botnick")

    # Print numbered list
    echo "$index. $server"$'\t'"$botnick"
    ((index++))
done

# Prompt user to choose IRC Bot
read -p "Please select the IRC Bot: " choice

# Validate user input
if [[ $choice =~ ^[0-9]+$ ]]; then
    if [ $choice -ge 1 ] && [ $choice -le ${#server_botnick_array[@]} ]; then
        selected_item="${server_botnick_array[$((choice - 1))]}"
        echo "You selected: $selected_item"

        # Prompt user for room name or nickname
        read -p "Please enter a room name or nickname: " room_or_nick
        echo "You entered: $room_or_nick"

        # Ask if it's an encrypted session or standard session
        read -p "Is this an encrypted session? (yes/no): " encrypted_session
        case "$encrypted_session" in
            yes|Yes|YES|y|Y)
                echo "Encrypted session selected."
                read -s -p "Enter password: " password
                echo ""

                # Execute encrypted_room.sh with server, botnick, room/nickname, and password
                ./encrypted_room.sh "$server" "$botnick" "$room_or_nick" "$password"
                ;;
            no|No|NO|n|N)
                echo "Standard session selected."

                # Execute room.sh with server, botnick, and room/nickname
                ./room.sh "$server" "$botnick" "$room_or_nick"
                ;;
            *)
                echo "Invalid input. Assuming standard session."
                ;;
        esac

    else
        echo "Invalid choice. Please enter a valid number."
    fi
else
    echo "Invalid input. Please enter a number."
fi

# Optional: Check if no files are found
if [ $(ls /tmp/irc_bot_socket_* 2>/dev/null | wc -l) -eq 0 ]; then
    echo "No files found matching /tmp/irc_bot_socket_*"
fi

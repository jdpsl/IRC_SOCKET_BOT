```bash
  _____ _____   _____    _____  ____   _____ _  ________ _______ 
 |_   _|  __ \ / ____|  / ____|/ __ \ / ____| |/ /  ____|__   __|
   | | | |__) | |      | (___ | |  | | |    | ' /| |__     | |   
   | | |  _  /| |       \___ \| |  | | |    |  < |  __|    | |   
  _| |_| | \ \| |____   ____) | |__| | |____| . \| |____   | |   
 |_____|_|  \_\\_____| |_____/ \____/ \_____|_|\_\______|  |_|   
                   ______                                        
                  |______|                                       
```
# Simple IRC Client/Bot

This project is a straightforward IRC client/bot that uses a socket for more advanced and non integrated scripts.

## Features

- **Unix Socket Creation**: Creates a Unix socket at `/tmp/irc_bot_socket`.
- **Dynamic Scripting**: Add scripts into the `scripts` folder, and the bot will execute them the next time it receives a line. No need to restart the bot or type reload commands.
- **Automatic Execution**: Every time it receives a line from the server, it will execute each of the files in the `scripts` directory and send the output.

## How to Run

To run the bot, use the following command:

```bash
python3 irc_sock.py
```

## Sending to a Specific Room or User
This project is meant to have everything split apart from the main bot that is running.
To send messages to a specific room or user, run the following command in a new terminal:

```bash
./window.sh $room_or_user
```


## Script Arguments

Scripts should follow this structure:

```bash
#!/bin/bash
message="$1"
channel="$2"
user="$3"
botnick="$4"
```

## Interaction with the Socket

If you want to perform actions other than sending the standard message to a room or person, interact with the socket directly. For example, to poke someone:

```bash
echo "PRIVMSG #0x90 :Hello" | socat - UNIX-CONNECT:/tmp/irc_bot_socket
```



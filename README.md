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

- **Unix Socket Creation**: Creates a Unix socket at `/tmp/irc_bot_socket_<server>_<botnick>`.
- **Dynamic Scripting**: Add scripts into the `scripts` folder, and the bot will execute them the next time it receives a line. No need to restart the bot or type reload commands.
- **Automatic Execution**: Every time it receives a line from the server, it will execute each of the files in the `scripts` directory and send the output.

## How to Run

To run the bot, use the following command:

```bash
python3 irc_sock.py <irc_server> <#default_channel> <bots nickname>
```


## Script Arguments

Scripts should follow this structure in the `scripts` folder:

```bash
#!/bin/bash
message="$1"
channel="$2"
user="$3"
botnick="$4"
thesocket="$5"

```

## Interaction with the Socket

If you want to perform actions other than sending the standard message to a room or person, interact with the socket directly. For example, to poke someone:

```bash
echo "PRIVMSG #0x90 :Hello" | socat - UNIX-CONNECT:$thesocket
```


## Sending to a Specific Room or User
This project is meant to have everything split apart from the main bot that is running.
To send messages to a specific room or user, run the following command in a new terminal:

```bash
./window.sh $room_or_user
```


### Encrypted Messages

Add a key to `./etc/key`
It will automatically decrypt messages sent by another user using this bot client when they use `./encrypted_room.sh`
```bash
./encrypted_room.sh "#0x90" "password"
```


### The Console Script

Run the command below to list all bot sessions currently running. This will let you choose which one you want to use and if you want it to be encrypted or unencrypted along with the user and room you want to interact with as a human.
```bash
./start_console
```

### List all the current sockets

```bash
./list_sockets.sh
```

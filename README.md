# Simple IRC Client/Bot

This project is a straightforward IRC client/bot.

## Features

- **Unix Socket Creation**: Creates a Unix socket at `/tmp/irc_bot_socket`.
- **Dynamic Scripting**: Add scripts into the `scripts` folder, and the bot will execute them the next time it receives a line. No need to restart the bot or type reload commands.
- **Automatic Execution**: Every time it receives a line from the server, it will execute each of the files in the `scripts` directory and send the output.

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



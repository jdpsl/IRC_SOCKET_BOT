Just a simple IRC client/bot
It creates a unix socket at /tmp/irc_bot_socket
You can add scripts into the scripts folder and the next time it receives a line, it will execute it, no need to restart the bot or type reload commands.
every time it receives a line from the server, it will execute each of the files in the scripts directory and send the output, script arguments should be as followed

#!/bin/bash
message="$1"
channel="$2"
user="$3"
botnick="$4"

If you want to do something other then the standard message to a room or person, you should interact with the socket
echo "PRIVMSG #0x90 :Hello" | socat - UNIX-CONNECT:/tmp/irc_bot_socket

lets say you want to poke someone

https://github.com/jdpsl/IRC_SOCKET_BOT/blob/main/scripts/poke

<?php

$unix_socket_path = '/tmp/irc_bot_socket';
$message = "PRIVMSG #example_channel :Hello from external script!\n";

function main() {
    global $unix_socket_path, $message;

    // Open a Unix domain socket connection
    $socket = stream_socket_client("unix://$unix_socket_path", $errno, $errstr);

    if (!$socket) {
        echo "Failed to connect: $errstr ($errno)\n";
        return;
    }

    // Send the message
    fwrite($socket, $message);

    echo "Sent message to IRC bot: $message";

    // Close the socket connection
    fclose($socket);
}

main();
?>

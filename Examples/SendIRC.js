// Node.js
const net = require('net');
const unixSocketPath = '/tmp/irc_bot_socket';
const message = "PRIVMSG #example_channel :Hello from external script!\n";

function main() {
    const client = net.createConnection(unixSocketPath);

    client.on('connect', () => {
        console.log('Connected to IRC bot');
        client.write(message);
        console.log(`Sent message to IRC bot: ${message.trim()}`);
    });

    client.on('error', (err) => {
        console.error('Error connecting to IRC bot:', err);
    });

    client.on('close', () => {
        console.log('Connection closed');
    });
}

main();

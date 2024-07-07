#include <stdio.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <string.h>

#define UNIX_SOCKET_PATH "/tmp/irc_bot_socket"

void main() {
    int client_socket;
    struct sockaddr_un server_address;
    char *message = "PRIVMSG #example_channel :Hello from external script!";
    int message_len = strlen(message) + 1;

    // Create socket
    client_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (client_socket == -1) {
        perror("Socket creation failed");
        return;
    }

    // Set server address
    memset(&server_address, 0, sizeof(server_address));
    server_address.sun_family = AF_UNIX;
    strncpy(server_address.sun_path, UNIX_SOCKET_PATH, sizeof(server_address.sun_path) - 1);

    // Connect to server
    if (connect(client_socket, (struct sockaddr *) &server_address, sizeof(server_address)) == -1) {
        perror("Connection failed");
        close(client_socket);
        return;
    }

    // Send message
    if (send(client_socket, message, message_len, 0) == -1) {
        perror("Send failed");
    } else {
        printf("Sent message to IRC bot: %s\n", message);
    }

    // Close socket
    close(client_socket);
}

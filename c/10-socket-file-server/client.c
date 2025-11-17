#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#define PORT 6490

int main() {
    int sockfd;
    char filename[40], buffer[20000];
    struct sockaddr_in server_addr;

    // Create socket
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        exit(1);
    }

    // Prepare server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);

    // Convert IP properly (this solves the inet_addr warning)
    if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(1);
    }

    memset(&(server_addr.sin_zero), 0, sizeof(server_addr.sin_zero));

    // Connect
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(1);
    }

    printf("CLIENT connected to SERVER.\n");
    printf("Enter the filename to be displayed: ");

    if (fgets(filename, sizeof(filename), stdin) == NULL) {
        perror("fgets");
        close(sockfd);
        exit(1);
    }

    filename[strcspn(filename, "\n")] = '\0';

    // Send file name
    if (send(sockfd, filename, strlen(filename), 0) == -1) {
        perror("send");
        close(sockfd);
        exit(1);
    }

    // Receive file data
    int numbytes = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    if (numbytes <= 0) {
        perror("recv");
        close(sockfd);
        exit(1);
    }

    buffer[numbytes] = '\0';

    printf("\n=== CONTENTS OF '%s' ===\n\n", filename);
    printf("%s\n", buffer);

    close(sockfd);
    return 0;
}

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h> 
#include <sys/time.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char **argv) {
	unsigned long msec;
	int sockfd; 
	int portno; 
	int clientlen;
	struct sockaddr_in serveraddr;
	struct sockaddr_in clientaddr;
	struct hostent *hostp; /* client host info */
	char buf[100];
	char fname[100];
	int connections = 0 ,i =0, optval,n;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <port> <connections-to-wait>\n", argv[0]);
		exit(1);
	}

	portno = atoi(argv[1]);
	connections = atoi(argv[2]);
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);

	if (sockfd < 0) 
		printf("ERROR opening socket");
	optval = 1;
	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, 
			(const void *)&optval , sizeof(int));
	bzero((char *) &serveraddr, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
	serveraddr.sin_port = htons((unsigned short)portno);

	if (bind(sockfd, (struct sockaddr *) &serveraddr,sizeof(serveraddr)) < 0) 
		printf("ERROR on binding");
	clientlen = sizeof(clientaddr);

	while (1) {
		i=0;
		while(1){
			bzero(buf, 100);
			n = recvfrom(sockfd, buf, 100, 0,
					(struct sockaddr *) &clientaddr, &clientlen);
			if (n < 0)
				printf("ERROR in recvfrom");
			i++;
			if (i == connections ) {
				close(sockfd);
				return 0;
			}
		}
	}
}

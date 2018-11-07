/* Source migration agent.
 * @author Spoorti Doddamani (sdoddam1@binghamton.edu)
 * @author Kevin Cheng       (tcheng8@binghamton.edu)
 * @author Aprameya Bhat     (abhat3@binghamton.edu)
 * @author Kartik Gopalan    (kartik@binghamton.edu)
 * @since  04/03/2018
 */

#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <string.h>
#include <stdbool.h>

#define PORT1 7777
#define PORT2 9797
#define PORT3 3535
#define SIZE 150

int main(int argc, char **argv) {

	/* Check the command line arguments. */
	if (argc != 4) {
		fprintf(stderr, "Usage: %s <VM IP> <DESTINATION IP> <MESSAGE>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	char *background = "&";
	char *command1, *command2, *command3;
	int port = 1111;
	int is_connected = -1;
	char buffer[SIZE];
	int bytes_read;
	int opt = 1;
	int backlog = 1;

	int socket_fd1;
	int socket_fd2;
	int socket_fd3;

	/* Server address. */
	struct sockaddr_in address1;
	struct sockaddr_in address2;
	struct sockaddr_in address3;

	/* Create TCP socket fd. */
	socket_fd1 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd1 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	socket_fd2 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd2 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	socket_fd3 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd3 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	/* Convert IPv4 address from text to binary. */
	memset(&address1, '0', sizeof(struct sockaddr_in));
	address1.sin_family = AF_INET;
	address1.sin_port = htons(PORT1);
	if(inet_pton(AF_INET, argv[1], &address1.sin_addr) < 0) {
		perror("inet_pton");
		exit(EXIT_FAILURE);
	}

	/* Connect to server. */
	/* Connect to guest machine.
	 */
	do {
		is_connected = connect(socket_fd1, (struct sockaddr*)&address1, sizeof(address1));
	} while(is_connected < 0);

	/* Once connected, 
	 * Send message "prepare" to setup migration 
	 * enviroment in guest
	 */
	send(socket_fd1, argv[3], strlen(argv[3]), 0);

	/* Read from the socket*/
	/* Read "prepared" message from guest machine 
	 */
	memset(buffer, '\0', SIZE);
	bytes_read = read(socket_fd1, buffer, SIZE);
	if (bytes_read < 0)
	{   
		perror("read");
		exit(EXIT_FAILURE);
	}   

	if (strcmp("prepared", buffer) == 0)
	{

		/*Convert IPv4 address from text to binary. */
		memset(&address3, '0', sizeof(struct sockaddr_in));
		address3.sin_family = AF_INET;
		address3.sin_port = htons(PORT2);
		if(inet_pton(AF_INET, argv[2], &address3.sin_addr) < 0)
		{
			perror("inet_pton");
			exit(EXIT_FAILURE);
		}   

		/* Connect to server.*/
		/* Connect to destination host machine.
		 */
		do{ 
			is_connected = connect(socket_fd3, (struct sockaddr*)&address3, sizeof(address3));
		}while(is_connected < 0); 

		/* Once connected, 
		 * Send message "prepare" to setup migration environment
		 */
		send(socket_fd3, argv[3], strlen(argv[3]), 0); 


		/* Set the TCP socket option */
		if (setsockopt(socket_fd2, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
			perror("setsockopt");
			exit(EXIT_FAILURE);
		}

		/* Bind to the port. */
		memset(&address2, '0', sizeof(struct sockaddr_in));
		address2.sin_family = AF_INET;
		address2.sin_addr.s_addr = INADDR_ANY;
		address2.sin_port = htons(PORT3);
		if(bind(socket_fd2, (struct sockaddr*)&address2, sizeof(struct sockaddr)) < 0)
		{
			perror("bind");
			exit(EXIT_FAILURE);
		}

		/* Listen to connection*/
		if(listen(socket_fd2, backlog) < 0)
		{
			perror("listen");
			exit(EXIT_FAILURE);
		}

		do
		{
			int socket1;

			/* Accept the connection*/
			socklen_t address_len = sizeof(address2);
			socket1 = accept(socket_fd2, (struct sockaddr*)&address2, (socklen_t*)&address_len);
			if (socket1 < 0)
			{   
				perror("accept");
				exit(EXIT_FAILURE);
			}   

			bytes_read = -1;
			memset(buffer, '\0', SIZE);
			bytes_read = read(socket1, buffer, SIZE);
			if (bytes_read < 0)
			{   
				perror("read");
				exit(EXIT_FAILURE);
			}

			command1 = "bash prepare_and_migrate.sh";
			snprintf(buffer,
					strlen(command1) + strlen(background) + strlen(argv[2]) + strlen(background) +
					sizeof(int) + strlen(background), 
					"%s %s %d", command1, argv[2], port);
			system(buffer);

			//Check migration status; send message on completion
			command2 = "bash migration_status.sh";
			system(command2);

			//command3 = "bash setup_vf.sh 0";
			//system(command3);

		}while(true);
	}
	close(socket_fd3);
	close(socket_fd2);
	close(socket_fd1);
	return 0;
}

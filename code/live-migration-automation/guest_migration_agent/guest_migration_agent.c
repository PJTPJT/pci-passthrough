/* Guest migration agent.
 * @author Spoorti Doddamani (sdoddam1@binghamton.edu)
 * @author Kevin Cheng       (tcheng8@binghamton.edu)
 * @author Aprameya Bhat     (abhat3@binghamton.edu)
 * @author Kartik Gopalan    (kartik@binghamton.edu)
 * @since  06/29/2018
 */

#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <stdbool.h>
#include <sys/time.h>
#include <arpa/inet.h>

#define PORT1 7777
#define PORT2 1818
#define SIZE 100

int main(int argc, char **argv) {


	if(argc != 4) {
		fprintf(stderr, "Usage: %s <HOST IP> <MESSAGE> <DEST IP>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int opt = 1;
	int backlog = 1;
	char *command1, *command2, *command3;

	int socket_fd1;
	int socket_fd2;
	struct sockaddr_in address1;
	struct sockaddr_in address2;

	/* Create TCP socket fd. */
	socket_fd1 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd1 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	/* Create TCP socket fd. */
	socket_fd2 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd2 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	/* Set the TCP socket option. */
	if (setsockopt(socket_fd1, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
		perror("setsockopt");
		exit(EXIT_FAILURE);
	}

	/* Bind to the port. */
	memset(&address1, '0', sizeof(struct sockaddr_in));
	address1.sin_family = AF_INET;
	address1.sin_addr.s_addr = INADDR_ANY;
	address1.sin_port = htons(PORT1);
	if(bind(socket_fd1, (struct sockaddr*)&address1, sizeof(struct sockaddr)) < 0) {
		perror("bind");
		exit(EXIT_FAILURE);
	}

	/* Listen to connection */
	if(listen(socket_fd1, backlog) < 0)
	{
		perror("listen");
		exit(EXIT_FAILURE);
	} 

	do
	{
		int socket1;
		char buffer[SIZE];
		int bytes_read;

		/* Accept the connection*/
		socklen_t address_len = sizeof(address1);
		socket1 = accept(socket_fd1, (struct sockaddr*)&address1, (socklen_t*)&address_len);
		if (socket1 < 0)
		{
			perror("accept");
			exit(EXIT_FAILURE);
		}

		/* Read from the socket*/
		/* Read "prepare" message from source host 
		 * to prepare guest for migration.
		 * Remove vfio interface and set mac address for 
		 * bonding interface.
		 */
		memset(buffer, '\0', SIZE);
		bytes_read = read(socket1, buffer, SIZE);
		if (bytes_read < 0)
		{
			perror("read");
			exit(EXIT_FAILURE);
		}

		if (strcmp("prepare", buffer) == 0)
		{
			command1 = "bash remove_vfio_interface.sh" ;
			system(command1);

			/* Once connected, send the message "prepared" to 
			 * source host machine.
			 */
			send(socket1, argv[2], strlen(argv[2]), 0);

			/* Set the TCP socket option. */
			if (setsockopt(socket_fd2, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt)) < 0) {
				perror("setsockopt");
				exit(EXIT_FAILURE);
			}

			/* Bind to the port. */
			memset(&address2, '0', sizeof(struct sockaddr_in));
			address2.sin_family = AF_INET;
			address2.sin_addr.s_addr = INADDR_ANY;
			address2.sin_port = htons(PORT2);
			if(bind(socket_fd2, (struct sockaddr*)&address2, sizeof(struct sockaddr)) < 0) {
				perror("bind");
				exit(EXIT_FAILURE);
			}

			/* Listen to connection */
			if(listen(socket_fd2, backlog) < 0)
			{
				perror("listen");
				exit(EXIT_FAILURE);
			} 

			do
			{
				int socket2;
				char buffer2[SIZE];
				int bytes_read;

				/* Accept the connection*/
				socklen_t address_len = sizeof(address2);
				socket2 = accept(socket_fd2, (struct sockaddr*)&address2, (socklen_t*)&address_len);
				if (socket2 < 0)
				{
					perror("accept");
					exit(EXIT_FAILURE);
				}

				/* Read from the socket*/
				/* Read "connected" message from destination host 
				 * to make sure VM is up.
				 */
				memset(buffer2, '\0', SIZE);
				bytes_read = read(socket2, buffer2, SIZE);
				if (bytes_read < 0)
				{
					perror("read");
					exit(EXIT_FAILURE);
				}
				send(socket2, argv[2], strlen(argv[2]), 0);

				/* Check if vfio interface is up 
   				 * after NIC hotplug
				 * Blocks till the interface is up
				 */ 
				command2 = "bash check_vfio_interface_up.sh";
				system(command2);

				/* Setup bonding driver by switching 
				 * vfio interface as active slave and
				 * set mac address of bond driver
				 */
				command3 = "bash setup_dest_bonding_driver.sh";
				system(command3);
				break;

			}while(true);

		}

	}while(true);

	close(socket_fd2);
	close(socket_fd1);
	return 0;

}

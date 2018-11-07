
/* Live migration automation.
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

#define PORT1 9797
#define PORT2 1818 
#define SIZE 150

int main(int argc, char **argv) {

	if (argc != 4) {
		fprintf(stderr, "Usage: %s <VM IP> <MESSAGE1> <MESSAGE2>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int vcpu = 1;
	int memory = 1024;
	char *vm_image = "/spoorti/vm-images/c3po.qcow2";
	int number_of_virtual_functions = 1;
	char *interface = "enp7s0f1";
	int virtual_function_index = 0;
	char *mac_address = "00:25:90:d8:aa:ee";
	char *command1, *command2, *command3;
	char *background = "&";
	int opt = 1;
	int backlog = 1;
	int is_connected = -1;

	int socket_fd1;
	int socket_fd2;
	struct sockaddr_in address1;
	struct sockaddr_in address2;

	/* Create a TCP socket fd. */
	socket_fd1 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd1 < 0) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	/* Create a TCP socket fd. */
	socket_fd2 = socket(AF_INET, SOCK_STREAM, 0);
	if (socket_fd1 < 0) {
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

	/* Listen to connection*/
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
		memset(buffer, '\0', SIZE);
		bytes_read = read(socket1, buffer, SIZE);
		if (bytes_read < 0)
		{
			perror("read");
			exit(EXIT_FAILURE);
		}

		if (strcmp("prepare", buffer) == 0)
		{
      //printf("Received prepare message\n");
			/* Setup virtual function;
			 * Unbind virtual function from host;
			 * Start destination guest.
			 */
			command1 = "bash prepare_destination_for_migration.sh";
			snprintf(buffer, strlen(command1) + strlen(mac_address) + strlen(vm_image) 
					+ strlen(interface) + strlen(background) * 5 + sizeof(int) * 4, 
					"%s %d %d %s %d %s %d %s %s", 
					command1, vcpu, memory, vm_image, number_of_virtual_functions, 
					interface, virtual_function_index, mac_address, background);
			system(buffer);

			//Check if the destination is up
			command2 = "bash check_destination_status.sh";
			system(command2);
		}

    //On hotplug message, run top half commands
    if (strcmp("hotplug", buffer) == 0){
      //printf("received hotplug message\n");
      sleep(2);
      command3 = "bash hotplug_top_half_vf.sh";
      system(command3);
    }
  

		//On migration completion message, plug vfio nic 
		if (strcmp("Done", buffer) == 0)
		{

			memset(&address2, '0', sizeof(struct sockaddr_in));
			address2.sin_family = AF_INET;
			address2.sin_port = htons(PORT2);
			if(inet_pton(AF_INET, argv[1], &address2.sin_addr) < 0){
				perror("inet_pton");
				exit(EXIT_FAILURE);
			}

			/* Connect to server. */
			/* Connect to guest machine to check if VM is up after migration
			 */
			do {
				is_connected = connect(socket_fd2, (struct sockaddr*)&address2, sizeof(address2));
			} while(is_connected < 0); 
			send(socket_fd2, argv[3], strlen(argv[3]), 0);

			/* Read from the socket*/
			memset(buffer, '\0', SIZE);
			bytes_read = read(socket_fd2, buffer, SIZE);
      //printf("Received %s from guest\n", buffer);
			if (bytes_read < 0)
			{
				perror("read");
				exit(EXIT_FAILURE);
			}

			//Hot plug vfio NIC
			//command2 = "bash hot_switch_vfio_nic.sh plug";
			command2 = "bash hotplug_bottom_half_vf.sh";
			system(command2);

		} 

	}while(true);

	close(socket_fd2);
	close(socket_fd1);
	return 0;
}

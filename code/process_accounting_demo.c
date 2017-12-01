/**
 * It has been reported that Process accounting sometimes does not work.
 * source: https://bugzilla.kernel.org/show_bug.cgi?id=190271
 * @author Kevin Cheng       (tcheng8@binghamton.edu)
 * @author Spoorti Doddamani (sdoddam1@binghamton.edu)
 * @author Kartik Gopalan    (kartik@binghamton.edu)
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define ACCTFILE  "/tmp/mypacct"

int main(void) {
  int  fd;
  char buf[1024];

  if ( (fd = open(ACCTFILE, O_RDWR|O_CREAT|O_TRUNC, 0777)) == -1) {
    perror("Open " ACCTFILE);
    exit(1);
  }

  if (acct(ACCTFILE) == -1) {
    perror("Switch on accounting");
    exit(1);
  }

  if (fork() == 0)  // fork new process
    exit(0);        // child process: finish


  // parent process:
  //wait for child to finish

  wait((int *)0);

  //  read the process accounting record of the finished child
  while (read(fd, buf, sizeof buf) == 0)
  {
    printf("No process accounting record yet....\n");
    sleep(1);
  }
  printf("Yeeeeah, found a process accounting record!\n");

  return 0;
}

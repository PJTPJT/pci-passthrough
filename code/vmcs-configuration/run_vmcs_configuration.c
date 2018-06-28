/**
 * Read/Write VMCS fields.
 * @author Kevin Cheng
 * @since  05/26/2018
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <string.h>

#include "vmcs.h"

void read_vmcs_field(int fd, vmcs_field_t *data) {
  if(ioctl(fd, READ_VM_EXEC_CONTROL, data) < 0)
    perror("ioctl");
}

void write_vmcs_field(int fd, vmcs_field_t *data) {
  if(ioctl(fd, WRITE_VM_EXEC_CONTROL, data) < 0)
    perror("ioctl");
}

void print(const vmcs_field_t *data) {
  printf("0x%016llx\n", data -> value);
}

int main(int argc, char *argv[]) {
  /* Check the command line arguments. */
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <OP> <FIELD> [SHIFT]\n", argv[0]);
    return 1;
  }

  /* Open the misc. device. */
  int fd = open(DEVICE, O_RDWR);
  if (fd < 0) {
    perror("open");
    return errno;
  }
  char *op = argv[1];
  unsigned long field = (unsigned long) strtol(argv[2], NULL, 16);

  /* Get the shifts. */
  int shift = 0;
  if (argc == 4) shift = atoi(argv[3]);

  /* IOCTL. */
  vmcs_field_t data = {0, 0};
  data.field = field;

  if (strcmp("r", op) == 0) {
    read_vmcs_field(fd, &data);
    print(&data);
  }
  else if (strcmp("w", op) == 0) {
    if (shift >= 0) {
      read_vmcs_field(fd, &data);
      data.value = data.value ^ (1 << shift);
      write_vmcs_field(fd, &data);
      print(&data);
    }
  }
  else fprintf(stderr, "ERROR: no such operation.\n");

  close(fd);
  return 0;
}

#if 0
  switch (op) {
    case 1:
      data.field = PIN_BASED_VM_EXEC_CONTROL;
      read_vmcs_field(fd, &data);
      print(&data);
      break;
    case 2:
      if (shift >= 0) {
        data.field = PIN_BASED_VM_EXEC_CONTROL;
        read_vmcs_field(fd, &data);
        data.value = data.value ^ (1 << shift);
        write_vmcs_field(fd, &data);
        print(&data);
      }
      break;
    case 3:
      data.field = CPU_BASED_VM_EXEC_CONTROL;
      read_vmcs_field(fd, &data);
      print(&data);
      break;
    case 4:
      if (shift >= 0) {
        data.field = CPU_BASED_VM_EXEC_CONTROL;
        read_vmcs_field(fd, &data);
        data.value = data.value ^ (1 << shift);
        write_vmcs_field(fd, &data);
        print(&data);
      }
      break;
    case 5:
      data.field = SECONDARY_VM_EXEC_CONTROL;
      read_vmcs_field(fd, &data);
      print(&data);
      break;
    case 6:
      if (shift >= 0) {
        data.field = SECONDARY_VM_EXEC_CONTROL;
        read_vmcs_field(fd, &data);
        data.value = data.value ^ (1 << shift);
        write_vmcs_field(fd, &data);
        print(&data);
      }
      break;
    default:
      fprintf(stderr, "No such option.\n");
  }
#endif



/**
 * We would like to update the vCPU behavior by updating the
 * VMX control bits.
 * @author Kevin Cheng
 * @since  05/25/2018
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

#include "vmx.h"

static void enable_intercept_msr_x2apic(int fd, msr_x2apic_t *data) {
  if (ioctl(fd, VMX_ENABLE_INTERCEPT_MSR_X2APIC, data) < 0) {
    perror("ioctl");
  }
}

static void disable_intercept_msr_x2apic(int fd, msr_x2apic_t *data) {
  if (ioctl(fd, VMX_DISABLE_INTERCEPT_MSR_X2APIC, data) < 0) {
    perror("ioctl");
  }
}

int main(int argc, char *argv[]) {
  /* Check the command line arguments. */
  if (argc < 4) {
    fprintf(stderr, "Usage: %s <ENABLE/DISABLE> <R/W> <MSR>\n", argv[0]);
    return 1;
  }
  char *action = argv[1];
  char *type = argv[2];
  u32 msr = (u32) strtoul(argv[3], NULL, 16);

  /* Convert to MSR access type. */
  int access_type = 0;
  if (strcmp("r", type) == 0) access_type = MSR_TYPE_R; 
  else if (strcmp("w", type) == 0) access_type = MSR_TYPE_W; 
  else {
    fprintf(stderr, "No such MSR access type.\n");
    return 1;
  }

  /* Open the misc. device. */
  int fd = open(DEVICE, O_RDWR);
  if (fd < 0) {
    perror("open");
    return errno;
  }
  
  /* Set or clear MSR read or write.*/
  msr_x2apic_t data = {msr, access_type, true};
  if (strcmp("enable", action) == 0)
    enable_intercept_msr_x2apic(fd, &data);
  else if (strcmp("disable", action) == 0)
    disable_intercept_msr_x2apic(fd, &data);
  else {
    fprintf(stderr, "No such action.\n");
    return 1;
  }

  close(fd);
  return 0;
}

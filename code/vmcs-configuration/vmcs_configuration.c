/**
 * Read/write the VMCS fields through the ioctl system calls.
 *
 * @author Kevin Cheng
 * @since  05/26/2018
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/miscdevice.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <asm/uaccess.h>

/* VMCS fields. */
#include <asm/vmx.h>

#include "vmcs.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Kevin Cheng");
MODULE_DESCRIPTION("Read/Write VMCS fields.");

/* OSNET-DTID
 * Need to make sure the symbols are exported.
 */
extern u64 vmcs_read64(unsigned long field);
extern void vmcs_write64(unsigned long field, u64 value);

static int my_open(struct inode *iobj, struct file *fobj) {
  return 0;
}

static int my_release(struct inode *iobj, struct file *fobj) {
  return 0;
}

static int read_vm_exec_control(unsigned long arg) {
  vmcs_field_t data;
  int is_bad = copy_from_user(&data,
                              (vmcs_field_t *)arg,
                              sizeof(vmcs_field_t));
  if (is_bad) return -EACCES;
  data.value= vmcs_read64(data.field);
  pr_info("0x%016llx\n", data.value);

  is_bad = copy_to_user((vmcs_field_t* )arg,
                        &data,
                        sizeof(vmcs_field_t));
  if (is_bad) return -EACCES;
  return 0;
}

static int write_vm_exec_control(unsigned long arg) {
  vmcs_field_t data;
  int is_bad = copy_from_user(&data,
                              (vmcs_field_t *)arg,
                              sizeof(vmcs_field_t));
  if (is_bad) return -EACCES;
  vmcs_write64(data.field, data.value);
  pr_info("0x%016llx\n", vmcs_read64(data.field));
  return 0;
}

static long my_ioctl(struct file *fobj,
                     unsigned int cmd, unsigned long arg) {
  switch (cmd) {
    case READ_VM_EXEC_CONTROL:
      read_vm_exec_control(arg);
      break;
    case WRITE_VM_EXEC_CONTROL:
      write_vm_exec_control(arg);
      break;
    default:
      pr_alert("No such an ioctl option.\n");
      return -EINVAL;
  }
  return 0;
}

/* Define the data structure of the file operations. */
static struct file_operations misc_device_operations = {
  .owner = THIS_MODULE,
  .open = my_open,
  .release = my_release,
  .unlocked_ioctl = my_ioctl,
};

/* Define the miscellaneous device. */
static struct miscdevice misc_device = {
  .minor = MISC_DYNAMIC_MINOR,
  .name = DEVICE_NAME,
  .fops = &misc_device_operations
};

static int __init my_initialize(void) {
  int is_error = misc_register(&misc_device);
  if (is_error < 0) {
    pr_alert("Failed to register the misc. device. \n");
    return -is_error;
  }
  else {pr_info("Register the misc. device successfully.\n");}
  return 0;
}

static void __exit my_exit(void) {
  misc_deregister(&misc_device);
  pr_info("Bye\n");
}

module_init(my_initialize);
module_exit(my_exit);

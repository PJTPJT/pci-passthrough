/**
 * We would like to change the VMX behavior by updating the
 * VMX control bits. To achieve such effect, we exposed the
 * VMX functions through vmx.h.
 *
 * Intel SDM Volume 4, Table 2-2: IA-32 Architectural MSRs.
 * @author Kevin Cheng
 * @since  05/25/2018
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/version.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <asm/uaccess.h>

#include "vmx.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Kevin Cheng");
MODULE_DESCRIPTION("Configure VMX through the control bits.");

/* VMX exported function. */
extern void vmx_disable_intercept_msr_x2apic(u32 msr,
                                             int type,
                                             bool apicv_active);
extern void osnet_vmx_enable_intercept_msr_x2apic(u32 msr,
                                                  int type,
                                                  bool apicv_active);

static int my_open(struct inode *iobj, struct file *fobj) {
  //pr_info("/dev/%s is open.\n", DEVICE_NAME);
  return 0;
}

static int my_release(struct inode *iobj, struct file *fobj) {
  //pr_info("/dev/%s is closed.\n", DEVICE_NAME);
  return 0;
}

static int enable_intercept_msr_x2apic(unsigned long arg) {
  msr_x2apic_t data;
  int is_bad = copy_from_user(&data,
                              (msr_x2apic_t*) arg,
                              sizeof(msr_x2apic_t));
  if (is_bad) return -EACCES;
  osnet_vmx_enable_intercept_msr_x2apic(data.msr,
                                        data.type,
                                        data.apicv_active);
  return 0;
}

static int disable_intercept_msr_x2apic(unsigned long arg) {
  msr_x2apic_t data;
  int is_bad = copy_from_user(&data,
                              (msr_x2apic_t*) arg,
                              sizeof(msr_x2apic_t));
  if (is_bad) return -EACCES;
  vmx_disable_intercept_msr_x2apic(data.msr,
                                   data.type,
                                   data.apicv_active);
  return 0;
}

static long my_ioctl(struct file *fobj,
                     unsigned int cmd, unsigned long arg) {
  switch (cmd) {
    case VMX_ENABLE_INTERCEPT_MSR_X2APIC:
      enable_intercept_msr_x2apic(arg);
      break;
    case VMX_DISABLE_INTERCEPT_MSR_X2APIC:
      disable_intercept_msr_x2apic(arg);
      break;
    default:
      pr_alert("NO such ioctl option.\n");
      return -EINVAL;
  }
  return 0;
} //end of my_ioctl

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

/**
 * Read the control fields of current active VMCS.
 *  - CPU based control field.
 *  - Pin based control field.
 * Error flags should be checked, after executing a VMX instruction.
 *  - If there is no current VMCS, RFLAGS.CF is set.
 *  - If there is a current VMCS, but an error occurs, RFLAGS.ZF is set and the
 *  processor set the error number to the VM-instruction error field (encoding
 *  0x4400).
 * Source: Intel Software Development Manual Volume 3B, 3C, 3D.
 * @author Kevin Cheng       (tcheng8@binghamton.edu)
 * @author Spoorti Doddamani (sdoddam1@binghamton.edu)
 * @author Kartik Gopalan    (kartik@binghamton.edu)
 * @since  12/22/2017
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/string.h>
#include <linux/seq_file.h>

#define PROC_ENTRY_NAME "vmcs_control_field"

static struct proc_dir_entry *proc_entry;
static int open(struct inode *, struct file *);
static int read_vmcs_control_field(struct seq_file *, void *);

static const struct file_operations file_operations = {
  .owner = THIS_MODULE,
  .open = open,
  .read = seq_read,
  .release = single_release,
};

static int __init initialize(void) {
  proc_entry = proc_create(PROC_ENTRY_NAME, 0644, NULL, &file_operations);
  printk(KERN_INFO "/proc/%s is created.\n", PROC_ENTRY_NAME);
  return 0;
}

static void __exit cleanup(void) {
  proc_remove(proc_entry);
  printk(KERN_INFO "Bye!\n");
}

static int open(struct inode *iobj, struct file *fobj) {
  printk(KERN_INFO "/proc/%s is opened.\n", PROC_ENTRY_NAME);
  return single_open(fobj, read_vmcs_control_field, NULL);
}

static int read_vmcs_control_field(struct seq_file *seq_file_obj, void *chrptr) {
  u32 error_code = 0x0;
  u64 cpu_based_control_field_bitmap = 0x0;
  u64 cpu_based_control_field_encoding = 0x4002;

  seq_printf(seq_file_obj, "BEFORE: error field: %08X\n", error_code);
  seq_printf(seq_file_obj, "BEFORE: CPU based control field: %016llX\n", cpu_based_control_field_bitmap);

  asm("mov    %2,    %%rax      \n"\
      "vmread %%rax, %0         \n"\
      "jc  .carry               \n"\
      "jmp .exit                \n"\
      ".carry:                  \n"\
      "  movl  $0xffffffff, %1  \n"\
      ".exit:                   \n"\
      : "=m" (cpu_based_control_field_bitmap), "=m" (error_code)
      : "r"  (cpu_based_control_field_encoding)
      : "rax"
     );

  seq_printf(seq_file_obj, "AFTER:  CPU based control field: %016llX\n", cpu_based_control_field_bitmap);
  seq_printf(seq_file_obj, "AFTER:  error field: %08X\n", error_code);
  seq_printf(seq_file_obj, "----------------------------------------\n");
  return 0;
}

module_init(initialize);
module_exit(cleanup);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Kevin Cheng");
MODULE_VERSION("0.1");
MODULE_DESCRIPTION("Read the control field of current active VMCS.");

/**
 * Write the new bitmap to control fields of current active VMCS.
 *  - CPU based control field (encoding 0x4002).
 *    + Disable the VM exit due to HLT by setting the bit position 7 to 0, where
 *    the bit position starts at 0.
 *  - Pin based control field (encoding 0x4000).
 *    + Disable the VM exit due to the external interrupts by setting the bit
 *    position 0 to 0, where the bit position starts at 0.
 * Error flags should be checked, after executing a VMX instruction.
 *  - If there is no current VMCS, RFLAGS.CF is set.
 *  - If there is a current VMCS, but an error occurs, RFLAGS.ZF is set and the
 *  processor set the error number to the VM-instruction error field (encoding
 *  0x4400).
 * Source: Intel Software Development Manual Volume 3B, 3C, 3D.
 * @author Kevin Cheng       (tcheng8@binghamton.edu)
 * @author Spoorti Doddamani (sdoddam1@binghamton.edu)
 * @author Kartik Gopalan    (kartik@binghamton.edu)
 * @since  12/25/2017
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/string.h>
#include <linux/seq_file.h>

#define PROC_ENTRY_NAME "write_vmcs_control_fields"
#define CF_ERROR 1
#define ZF_ERROR 2
#define PIN_BASED_EXECUTION_CONTROL_FIELD 0x4000
#define CPU_BASED_EXECUTION_CONTROL_FIELD 0x4002

static struct proc_dir_entry *proc_entry;
static int open(struct inode *, struct file *);
static int write_vmcs_control_fields(struct seq_file *, void *);
static int write_execution_control_field(struct seq_file *, u64, u64);
static void print_error(struct seq_file *, int);
 
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
  return single_open(fobj, write_vmcs_control_fields, NULL);
}

static void print_error(struct seq_file *seq_file_obj, int error) {
  if (error == 1) {
    seq_printf(seq_file_obj, "ERROR (RFLAGS.CF): no current VMCS.\n");
  }
  else if (error == 2) {
    seq_printf(seq_file_obj, "ERROR (RFLAGS.ZF): VM instruction error.\n");
  }
  else {;}
}

static int write_execution_control_field(struct seq_file *seq_file_obj,
                                         u64 encoding, u64 bit_position) {
  int error = 0;
  int cf_error = CF_ERROR;
  int zf_error = ZF_ERROR;
  u64 execution_control_field_bitmap = 0;
  asm("mov     %2,    %%rax     \n"\
      "vmread  %%rax, %%rbx     \n"\
      "jc  .carry               \n"\
      "jz  .zero                \n"\
      "mov     %5,    %%rcx     \n"\
      "btr     %%rcx, %%rbx     \n"\
      "clc                      \n"\
      "vmwrite %%rbx, %%rax     \n"\
      "jc  .carry               \n"\
      "jz  .zero                \n"\
      "jmp .exit                \n"\
      ".carry:                  \n"\
      "  movl  %3,   %1         \n"\
      "  jmp .exit              \n"\
      ".zero:                   \n"\
      "  movl  %4,   %1         \n"\
      "  jmp .exit              \n"\
      ".exit:                   \n"\
      : "=m" (execution_control_field_bitmap), "=m" (error)
      : "r"  (encoding), "r" (cf_error), "r" (zf_error), "r" (bit_position)
      : "rax", "rbx", "rcx"
     );
  print_error(seq_file_obj, error);
  return error;
}

static int write_vmcs_control_fields(struct seq_file *seq_file_obj,
                                    void *chrptr) {
  /* BUG: soft lockup */
  /* Disable the VM exit due to the external interrupts. */
  seq_printf(seq_file_obj, "Update PIN-based execution control field.\n");
  write_execution_control_field(seq_file_obj,
                                PIN_BASED_EXECUTION_CONTROL_FIELD, 0);

  /* Disable the HLT exiting. */
  //seq_printf(seq_file_obj, "Update CPU-based execution control field.\n");
  //write_execution_control_field(seq_file_obj,
  //                              CPU_BASED_EXECUTION_CONTROL_FIELD, 7);

  /* Disable the VMX preemption timer */
  //seq_printf(seq_file_obj, "Update PIN-based execution control field.\n");
  //write_execution_control_field(seq_file_obj,
  //                              PIN_BASED_EXECUTION_CONTROL_FIELD, 6);
  return 0;
}

module_init(initialize);
module_exit(cleanup);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Kevin Cheng, Spoorti Doddamani, Kartik Gopalan");
MODULE_VERSION("0.1");
MODULE_DESCRIPTION("Write the control fields of current active VMCS.");


/**
 * Read/Write VMCS fields.
 * @author Kevin Cheng
 * @since  05/27/2018
 */

#ifndef _VMCS_H
#define _VMCS_H

#define DEVICE_NAME "vmcs_configuration"
#define DEVICE "/dev/" DEVICE_NAME

typedef unsigned long long u64;
typedef struct vmcs_field_t {
  unsigned long field;
  u64 value;
} vmcs_field_t;

#define READ_VM_EXEC_CONTROL  _IOR('k', 1, vmcs_field_t *)
#define WRITE_VM_EXEC_CONTROL _IOR('k', 2, vmcs_field_t *)

#endif

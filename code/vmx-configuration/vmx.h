/**
 * We would like to update the vCPU behavior by updating the
 * VMX control bits.
 * @author Kevin Cheng
 * @since  05/27/2018
 */

#ifndef _VMX_H
#define _VMX_H

#define DEVICE_NAME "vmx_configuration"
#define DEVICE "/dev/" DEVICE_NAME

typedef unsigned int u32;
typedef _Bool bool;
typedef struct msr_x2apic_t {
  u32 msr;
  int type;
  bool apicv_active;
} msr_x2apic_t;

#define VMX_ENABLE_INTERCEPT_MSR_X2APIC  _IOR('k', 1, msr_x2apic_t *)
#define VMX_DISABLE_INTERCEPT_MSR_X2APIC _IOR('k', 2, msr_x2apic_t *)
#define true 1
#define false 0
#define MSR_TYPE_R  1
#define MSR_TYPE_W  2

#endif

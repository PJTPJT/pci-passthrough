# Configure VMX at the Run Time
We can see the behavior of VM execution by manipulating the
bits at the run time. Please note that updating one field may
have effect on other fields in the bitmap. We expose
"vmx_disable_intercept_msr_x2apic" and
"osnet_vmx_enable_intercept_msr_x2apic" to update the MSR
bitmap.

PCI Device Passthrough
----------------------
- Kevin Cheng       (tcheng8@binghamton.edu)
- Spoorti Doddamani (sdoddam1@binghamton.edu)
- Kartik Gopalan    (kartik@binghamton.edu)

KVM Patch
---------
v1
- Kernel 4.10.1
- Apply patch: git apply kvm_v1.patch
- vmx.c      Enable/disable the HLT exiting.
- x86.c      Time the handling of VM exits.
- kvm_main.c Initialize the variables and data structure to
             store the handling time.

TODO
----
- Make the KVM patch for the kernel 4.15.11.

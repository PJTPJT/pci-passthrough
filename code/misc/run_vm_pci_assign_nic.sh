#!/bin/bash

# Boot up the VM with the physical network interface card by pci-assign.
# We assume the VM disk image is in the raw format.

# Get on the input arguments.
if [[ $# != 4 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <VM IMAGE> <BDF>"
  exit 1
fi
vcpu=$1
memory=$2
vm_image=$3
bdf=$4

# Configure the VM in the background.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp ${vcpu} \
                   -m   ${memory} \
                   -hda ${vm_image} \
                   -net none \
                   -device pci-assign,host=${bdf},id=pci_assign_nic \
                   -nographic \
                   -monitor none \
                   -parallel none \
                   -serial none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

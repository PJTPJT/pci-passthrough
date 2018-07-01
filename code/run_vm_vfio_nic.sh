#!/bin/bash

# Boot up the VM with the VFIO NIC.

# Get the input arguments.
if [[ $# != 4 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <VM IMAGE> <NIC BDF>"
  exit 1
fi
vcpu=$1
memory=$2
vm_image=$3
bdf=$4

# Boot up the VM.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp ${vcpu} \
                   -m   ${memory} \
                   -hda ${vm_image} \
                   -net none \
                   -device vfio-pci,host=${bdf},id=vfio_pci_nic \
                   -nographic \
                   -monitor none \
                   -parallel none \
                   -serial none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

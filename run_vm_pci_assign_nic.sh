#!/bin/bash

# Boot up the VM with the physical network interface card by pci-assign.
# We assume the VM disk image is in the raw format.
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: ./$0 <NIC DEVICE ID> <VM IMG>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="$1"
vm_img="$2"

# Configure the VM in the background.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -drive file=${vm_img},format=raw \
                   -net none \
                   -device pci-assign,host=${nic_id},id=pci_assign_nic

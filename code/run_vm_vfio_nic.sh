#!/bin/bash

# Boot up the VM with the physical network interface card by vfio-pci.
# We assume the VM disk image is in the raw format.

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <NIC DEVICE ID> <VM IMG>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="$1"
vm_img="$2"

# Boot up the VM with the host network interface card by VFIO.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -drive file=${vm_img},format=raw,if=virtio \
                   -net none \
                   -device vfio-pci,host=${nic_id},id=vfio_pci_nic

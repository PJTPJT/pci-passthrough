#!/bin/bash

# Boot up the VM with virtio-net and the tap device and bridge network.
# We assume the VM disk image is in the raw format and the software
# bridge has been set up properly.
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: ./$0 <VM IMG>" 1>&2
  exit 1
fi

# Process the command line arguments.
vm_img="$1"

# Boot up the VM with the host network interface card by VFIO.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -drive file=${vm_img},format=raw \
                   -netdev tap,id=mytap,ifname=qtap0 \
                   -device virtio-net,netdev=mytap

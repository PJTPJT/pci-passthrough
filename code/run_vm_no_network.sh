#!/bin/bash

# Boot up the VM without any network.
# We assume the VM disk image is in the raw format.

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <VM IMG>" 1>&2
  exit 1
fi

# Process the command line arguments.
vm_img="$1"

# Boot up the VM without any network.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -drive file=${vm_img},format=raw,if=virtio \
                   -net none

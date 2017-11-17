#!/bin/bash

# Boot up the VM without any network. However, we can communicate with
# the QEMU by the QEMU machine protocol through the Unix domain sockets.
# We assume the VM disk image is in the raw format.
# @author Kevin Cheng
# @since  11/15/2017

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
                   -drive file=${vm_img},format=raw \
                   -net none \
                   -qmp unix:/tmp/qmp-socket,server

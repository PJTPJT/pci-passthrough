#!/bin/bash

# Boot up the VM without any network. However, we can communicate with
# the QEMU by the QEMU machine protocol through the Unix domain sockets.
# We assume the VM disk image is in the raw format.

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <VM IMG>" 1>&2
  exit 1
fi

# Remove the previous Unix domain socket.
if [[ -S "/tmp/qmp-socket" ]]; then rm "/tmp/qmp-socket"; fi

# Process the command line arguments.
vm_img="$1"

# Configure the VM without any network.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -drive file=${vm_img},format=raw,if=virtio \
                   -net none \
                   -qmp unix:/tmp/qmp-socket,server &

# Trigger to boot up the VM by sending a null message through the unix
# domain socket.
while [[ ! -S "/tmp/qmp-socket" ]]; do :; done
cat /dev/null | nc -U /tmp/qmp-socket

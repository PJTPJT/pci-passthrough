#!/bin/bash

# Boot up the VM with vhost-net.

# Get the input arguments.
if [[ $# != 3 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <VM IMAGE>"
  exit 1
fi
vcpu=$1
memory=$2
vm_image=$3

# Load the vhost modules.
modprobe vhost-net

# Boot up the VM.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp ${vcpu} \
                   -m   ${memory} \
                   -hda ${vm_image} \
                   -netdev tap,id=mytap,ifname=qtap0,vhost=on \
                   -device virtio-net,netdev=mytap \
                   -nographic \
                   -monitor none \
                   -parallel none \
                   -serial none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

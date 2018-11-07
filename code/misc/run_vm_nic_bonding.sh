#!/bin/bash

# Boot up the VM with the assigned NIC and tap device.

# Get the command line arguments.
if [[ $# != 3 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <VM IMAGE>"
  exit 1
fi
vcpu=$1
memory=$2
vm_image=$3

# Boot up the guest.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp "${vcpu}" \
                   -m "${memory}" \
                   -object iothread,id=iothread0 \
                   -drive if=none,file="${vm_image}",format=raw,id=drive0,cache=writeback,aio=threads \
                   -device virtio-blk,iothread=iothread0,drive=drive0 \
                   -netdev tap,ifname=qtap0,id=mytap,vhost=on \
                   -device virtio-net,netdev=mytap \
                   -net none \
                   -device vfio-pci,host=07:00.1,id=assigned_nic \
                   -parallel none \
                   -monitor none \
                   -display none \
                   -qmp unix:/tmp/qmp-socket,server,nowait \
                   -serial telnet:127.0.0.1:8888,server,nowait
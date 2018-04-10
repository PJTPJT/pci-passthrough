#!/bin/bash -x

# Boot up the VM with the assigned NIC and tap device.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/01/2018

# Input parameters.
if [[ $# != 3 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <VM IMAGE>"
  exit 1
fi
vcpu=$1
memory=$2
vm_image=$3
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp "${vcpu}" \
                   -m "${memory}" \
                   -object iothread,id=iothread0 \
                   -drive if=none,file="${vm_image}",format=raw,id=drive0,cache=writeback,aio=threads \
                   -device virtio-blk,iothread=iothread0,drive=drive0 \
                   -net none \
                   -device vfio-pci,host=07:00.1,id=assigned_nic \
                   -netdev tap,ifname=qtap0,id=mytap,vhost=on \
                   -device virtio-net,netdev=mytap \
                   -qmp unix:/tmp/qmp-socket,server,nowait \
                   -serial none \
                   -parallel none \
                   -display none \
                   -monitor none

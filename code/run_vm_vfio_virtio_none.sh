#!/bin/bash

# Boot up the VM with the VFIO NIC and virtio-blk devices,
# where each iothread is associated with one partition. HDD is
# the guest's HD, while the SSD is the test target.

#cache = none
# This mode causes qemu-kvm to interact with the disk image
# file or block device with O_DIRECT semantics, so the host
# page cache is bypassed and I/O happens directly between the
# qemu-kvm userspace buffers and the storage device. Because
# the actual storage device may report a write as completed
# when placed in its write queue only, the guest's virtual
# storage adapter is informed that there is a writeback cache,
# so the guest would be expected to send down flush commands
# as needed to manage data integrity. Equivalent to direct
# access to your hosts' disk, performance wise. 

# Get the input arguments.
if [[ $# != 3 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <NIC BDF>"
  exit 1
fi
vcpu=$1
memory=$2
bdf=$3

# Boot up the VM.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp ${vcpu} \
                   -m   ${memory} \
                   -object iothread,id=iothread0 \
                   -drive if=none,file=/dev/sdb,format=raw,id=drive0,cache=none,aio=threads \
                   -device virtio-blk,iothread=iothread0,drive=drive0 \
                   -object iothread,id=iothread1 \
                   -drive if=none,file=/dev/sdc,format=raw,id=drive1,cache=none,aio=threads \
                   -device virtio-blk,iothread=iothread1,drive=drive1 \
                   -net none \
                   -device vfio-pci,host=${bdf},id=vfio_pci_nic \
                   -nographic \
                   -monitor none \
                   -parallel none \
                   -serial none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

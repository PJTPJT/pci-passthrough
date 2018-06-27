#!/bin/bash -x

# Boot up the VM with the assigned NIC and virtio-blk devices
# for the SSD and HDD.

# Configuration for the batch mode.
# https://linux.m2osw.com/qemu-tricks-and-reference
# Disable all the serial port.
# Disable all the parallel port.
# Disable the display.
# Disable the monitor.

qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 13312 \
                   -object iothread,id=iothread0 \
                   -drive if=none,file=/dev/sdb,format=raw,id=drive0,cache=writeback,aio=threads \
                   -device virtio-blk,iothread=iothread0,drive=drive0 \
                   -object iothread,id=iothread1 \
                   -drive if=none,file=/dev/sdc,format=raw,id=drive1,cache=writeback,aio=threads \
                   -device virtio-blk,iothread=iothread1,drive=drive1 \
                   -net none \
                   -device vfio-pci,host=07:00.1,id=assigned_nic \
                   -serial none \
                   -parallel none \
                   -display none \
                   -monitor none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

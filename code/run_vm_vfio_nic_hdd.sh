#!/bin/bash -x

# Boot up the VM with the assigned NIC and SSD.

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
                   -device vfio-pci,host=00:1f.2,id=assigned_sata \
                   -net none \
                   -device vfio-pci,host=07:00.1,id=assigned_nic \
                   -serial none \
                   -parallel none \
                   -display none \
                   -monitor none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

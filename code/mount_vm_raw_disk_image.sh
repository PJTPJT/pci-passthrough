#!/bin/bash

# Mount the VM raw disk image through the loop device.
# Here the mounting point is created in the current directory and has a
# name, vm-disk.

# Command line arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <VM RAW IMAGE>"
  exit 1
fi
vm=$1

# Get the next available loop device.
next_loop_device=$(losetup -f)

# Assume there is only one partition in the VM disk image.
# Find the start sector.
start_sector=$(fdisk -l ${vm} | tail -1 | awk '{print $3}')

# Find the sector size.
sector_size=$(fdisk -l ${vm} | grep Units | awk '{print $(NF-1)}')

# Mount the VM image to the loop device.
losetup --offset=$((${start_sector} * ${sector_size})) ${next_loop_device} ${vm}

# Create the mounting point.
if [[ ! -d "vm-disk" ]]; then
  mkdir vm-disk
fi

# Mount the loop device to our mounting point.
mount ${next_loop_device} vm-disk

#!/bin/bash

# Unmount the VM raw disk image.

# Get the command line arguments.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <VM DIR>"
  exit 1
fi
vm_dir=$1

# Unmount the loop device from our mounting point.
umount ${vm_dir}

# Get the used loop device.
loop_device=$(losetup | tail -1 | awk '{print $1}')

# Unmount the VM raw image to the loop device.
losetup -d ${loop_device}

# Clean up.
rmdir ${vm_dir}

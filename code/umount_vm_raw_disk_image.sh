#!/bin/bash

# Unmount the VM raw disk image through the loop device.
# Here the mounting point is created in the current directory
# and has a name, vm-disk.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/04/2018

# Command line arguments.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <VM DIR>"
  exit 1
fi
vm_dir=$1

# Unmount the loop device from our mounting point.
umount ${vm_dir}

# Get the used loop device.
# TODO: We assume the loop device is only used by the VM disk image.
loop_device=$(losetup | tail -1 | awk '{print $1}')

# Unmount the VM raw image to the loop device.
losetup -d ${loop_device}

# Clean up.
rmdir ${vm_dir}

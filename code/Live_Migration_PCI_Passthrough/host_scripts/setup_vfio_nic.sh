#!/bin/bash

# Set up the NIC passthrough via VFIO.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  03/28/2018

# Detect if the vfio-pci has been loaded.
lsmod | grep -ie "vfio-pci" &> /dev/null
if [[ $? = 1 ]]; then
  modprobe vfio-pci
fi

# Unbind the network interface card from the driver.
#echo "0000:07:00.1" > /sys/bus/pci/drivers/igb/unbind
echo "0000:07:10.1" > /sys/bus/pci/drivers/igbvf/unbind

# Bind the network interface card to VFIO.
#echo "8086 1521" > /sys/bus/pci/drivers/vfio-pci/new_id
echo "8086 1520" > /sys/bus/pci/drivers/vfio-pci/new_id

# Display the currently bound devices.
ls -l /sys/bus/pci/drivers/vfio-pci/

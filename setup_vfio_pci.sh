#!/bin/bash

# Set up vfio-pci
# The script require the user to have the root privilege.
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]];then
  echo "Usage: ./$0 <NIC DEVICE ID> <VENDOR ID>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="0000:$1"
nic_vendor_id=$(echo $2 | tr ':' ' ')

# Load the VFIO modules.
lsmod | grep -ie "vfio-pci" &> /dev/null
if [[ $? = 1 ]]; then
  modprobe vfio-pci
fi

# Unbind the network interface card from the host driver.
echo "${nic_id}" > "/sys/bus/pci/devices/${nic_id}/driver/unbind"
echo "${nic_id}" > "/sys/bus/pci/devices/${nic_id}/driver/bind"



## Bind the network interface card to VFIO.
#echo "8086 1521" > /sys/bus/pci/drivers/vfio-pci/new_id
#
## Unbind other network interface from VFIO.
#echo "0000:04:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
#echo "0000:04:00.1" > /sys/bus/pci/drivers/vfio-pci/unbind
#echo "0000:07:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
#tree /sys/bus/pci/drivers/vfio-pci/

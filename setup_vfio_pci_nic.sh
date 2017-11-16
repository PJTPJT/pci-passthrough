#!/bin/bash

# Set up vfio-pci
# The script requires the user to have the root privilege.
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
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

# Get the host NIC driver.
host_nic_driver=$(ls -l "/sys/bus/pci/devices/${nic_id}/driver" | awk -F'/' '{print $NF}')

# Unbind the network interface card from the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/unbind"

# Bind the network interface card to VFIO.
echo "${nic_vendor_id}" > "/sys/bus/pci/drivers/vfio-pci/new_id"
echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/bind"

#!/bin/bash

# Bind the NIC from the vfio-pci to the nic driver.

# Get the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <NIC BDF> <VENDOR ID>"
  exit 1
fi
bdf=$1
vendor=$2

# Get the host NIC driver.
nic_driver=$(ls -l "/sys/bus/pci/devices/${bdf}/driver" | awk -F'/' '{print $NF}')

# Unbind the NIC from vfio-pci.
echo "${bdf}" > "/sys/bus/pci/drivers/vfio-pci/unbind"

# Bind the physical network interface card to the host driver.
echo "${bdf}" > "/sys/bus/pci/drivers/${nic_driver}/bind"

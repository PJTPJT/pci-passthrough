#!/bin/bash

# Bind the NIC from its driver to the vfio-pci.

# Get the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <NIC BDF> <VENDOR ID>"
  exit 1
fi
bdf=$1
vendor=$2

# Load the VFIO modules.
lsmod | grep -ie "vfio-pci" &> /dev/null
if [[ $? = 1 ]]; then
  modprobe vfio-pci
fi

# Get the host NIC driver.
nic_driver=$(ls -l "/sys/bus/pci/devices/${bdf}/driver" | awk -F'/' '{print $NF}')

# Unbind the network interface card from the NIC driver.
echo "${bdf}" > "/sys/bus/pci/drivers/${nic_driver}/unbind"

# Bind the network interface card to VFIO.
echo "${vendor}" > "/sys/bus/pci/drivers/vfio-pci/new_id"
#echo "${bdf}" > "/sys/bus/pci/drivers/vfio-pci/bind"

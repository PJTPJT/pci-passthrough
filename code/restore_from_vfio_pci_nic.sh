#!/bin/bash

# Bind the NIC from the vfio-pci to the nic driver.

# Get the input arguments.
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <NIC BDF> <NIC DRIVER> <INTERFACE>"
  exit 1
fi
bdf=$1
driver=$2
interface=$3

# Unbind the NIC from vfio-pci.
echo "${bdf}" > /sys/bus/pci/drivers/vfio-pci/unbind

# Bind the physical network interface card to the host driver.
echo "${bdf}" > /sys/bus/pci/drivers/${driver}/bind

# Wake up the interface.
ifdown ${interface}
ifup ${interface}

#!/bin/bash

# Bind the physical network card from the pci-stub to the NIC
# driver.

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <NIC BDF>"
  exit 1
fi
bdf=$1

# Unbind the NIC from the pci-stub.
echo "${bdf}" > "/sys/bus/pci/drivers/pci-stub/unbind"

# Get the host NIC driver.
nic_driver=$(ls -l "/sys/bus/pci/devices/${bdf}/driver" | awk -F'/' '{print $NF}')

# Bind the physical network interface card to the host driver.
echo "${bdf}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

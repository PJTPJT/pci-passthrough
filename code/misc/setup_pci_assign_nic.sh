#!/bin/bash

# Bind the network interface card to the pci-stub.

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <NIC BDF> <VENDOR ID>"
  exit 1
fi
bdf=$1
vendor=$2

# Get the host NIC driver.
nic_driver=$(ls -l "/sys/bus/pci/devices/${bdf}/driver" | awk -F'/' '{print $NF}')

# Unbind the NIC interface card from the NIC driver.
echo "${bdf}" > /sys/bus/pci/drivers/${nic_driver}/unbind

# Bind the NIC to the pci-stub.
modprobe pci-stub
echo "${vendor}" > /sys/bus/pci/drivers/pci-stub/new_id
echo "${bdf}" > /sys/bus/pci/drivers/pci-stub/bind

#!/bin/bash

# Bind the physical network card back to the host driver.
# The script requires the user to have the root privilege.
# @author Kevin Cheng
# @since  11/16/2017

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <NIC DEVICE ID>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="0000:$1"
nic_vendor_id=$(echo $2 | tr ':' ' ')

# Get the host NIC driver.
host_nic_driver=$(ls -l "/sys/bus/pci/devices/${nic_id}/driver" | awk -F'/' '{print $NF}')

# Bind the physical network interface card to the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

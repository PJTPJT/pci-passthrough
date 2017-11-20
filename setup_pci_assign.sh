#!/bin/bash

# Set up pci-assign
# The script requires the user to have the root privilege.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  11/16/2017

# Check on the input arguments.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <NIC DEVICE ID>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="0000:$1"

# Get the host NIC driver.
host_nic_driver=$(ls -l "/sys/bus/pci/devices/${nic_id}/driver" | awk -F'/' '{print $NF}')

# Save the host NIC driver name to the file. The content will be used,
# when we need to switch the control back to the host NIC driver.
echo -n ${host_nic_driver} > host_nic.txt

# Unbind the network interface card from the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/unbind"

#!/bin/bash

# Bind the physical network card back to the host driver.
# The script requires the user to have the root privilege. We may need to call
# "setup_pci_assign.sh" to obtain the driver name of host NIC.
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
nic_vendor_id=$(echo $2 | tr ':' ' ')

# Get the host NIC driver.
host_nic_driver=$(cat "host_nic.txt")

# Bind the physical network interface card to the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

# Clean up.
rm "host_nic.txt"

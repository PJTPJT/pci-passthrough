#!/bin/bash

# Bind the physical network card back to the host driver.
# The script requires the user to have the root privilege. Before using this
# script, we need to run "setup_vfio_pci.sh" first.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <NIC DEVICE ID> <VENDOR ID>" 1>&2
  exit 1
fi

if [[ ! -f "host_nic.txt" ]]; then
  echo "ERROR: need to run the complementary script, setup_vfio_pci.sh first" 1>&2
  exit 2
fi

# Process the command line arguments.
nic_id="0000:$1"
nic_vendor_id=$(echo $2 | tr ':' ' ')

# Get the host NIC driver.
host_nic_driver=$(cat "host_nic.txt")

# Unbind the physical network interface card from vfio-pci
echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/unbind"
echo ${nic_vendor_id} > "/sys/bus/pci/drivers/vfio-pci/remove_id"

# Bind the physical network interface card to the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

# Clean up.
rm "host_nic.txt"

#!/bin/bash

# Set up vfio-pci
# The script requires the user to have the root privilege. This script
# should be executed before "restore_from_vfio_pci_nic.sh". After
# calling this script, it will save the original host NIC driver to a
# file, "host_nic.txt".
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <NIC DEVICE ID> <VENDOR ID>" 1>&2
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

# Save the host NIC driver name to the file. The content will be used,
# when we need to switch the control back to the host NIC driver.
echo -n ${host_nic_driver} > host_nic.txt

# Unbind the network interface card from the host driver.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/unbind"

# Bind the network interface card to VFIO.
echo "${nic_vendor_id}" > "/sys/bus/pci/drivers/vfio-pci/new_id"

# If binding the NIC to VFIO by the NIC's vendor is not sufficient, we
# can uncomment the line below.
#echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/bind"

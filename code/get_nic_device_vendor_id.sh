#!/bin/bash

# Assume that there is only one NIC having only one port.
# Retrieve the device and vendor ID for the network interface
# card (NIC).

# Get the NIC ID.
nic_id=$(lspci -nn | grep -ie 'ethernet' | awk '{print $1}')

# Use the NIC ID to get the vendor ID.
nic_vendor_id=$(lspci -n | grep -ie "${nic_id}" | awk '{print $3}')

# Print the device and vendor ID.
echo "${nic_id} ${nic_vendor_id}"

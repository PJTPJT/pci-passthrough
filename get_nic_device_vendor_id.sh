#!/bin/bash

# Retrieve the device and vendor ID for the network interface card (NIC).
# We assume that there is only one NIC, which has only one port, in the
# system.
# @author Kevin Cheng
# @since  11/15/2017

# Get the NIC ID.
nic_id=$(lspci -nn | grep -ie 'ethernet' | awk '{print $1}')

# Use the NIC ID to get the vendor ID.
nic_vendor_id=$(lspci -n | grep -ie "${nic_id}" | awk '{print $3}')

# Write the device and vendor ID to the stdout buffer.
echo "${nic_id} ${nic_vendor_id}"

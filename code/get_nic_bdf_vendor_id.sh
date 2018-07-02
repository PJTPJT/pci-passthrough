#!/bin/bash

# Assume that there is only one NIC having only one port.
# Get the bus:device.function and vendor ID for the network
# interface card (NIC).

# Get the BDF.
bdf=$(lspci -nn | grep -ie 'ethernet' | awk '{print $1}')

# Get the vendor ID.
vendor_id=$(lspci -n | grep -ie "${bdf}" | awk '{print $3}')

# Print the device and vendor ID.
echo "${bdf} ${vendor_id}"

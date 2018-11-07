#!/bin/bash

# Setup virtual function.
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

if [[ $# != 4 ]]; then
  echo "Usage: $0 <NUMBER OF VIRTUAL FUNCTIONS> <INTERFACE> <VIRTUAL FUNCTION INDEX> <MAC ADDRESS>"
  exit 1
fi

number_of_virtual_functions=$1
interface=$2
virtual_function_index=$3
mac_address=$4

# Create virtual function
echo $number_of_virtual_functions > /sys/class/net/$interface/device/sriov_numvfs

# Setup MAC address for the virtual function
#ip link set $interface vf $virtual_function_index mac $mac_address

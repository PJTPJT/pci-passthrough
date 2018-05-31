#!/bin/bash

if [[ $# != 3 ]]; then
  echo "Usage: $0 <INTERFACE> <VF INDEX> <MAC ADDRESS>"
  exit 1
fi

interface=$1
vf_idx=$2
mac_addr=$3

ip link set $interface vf $vf_idx mac $mac_addr

rmmod igbvf
modprobe igbvf

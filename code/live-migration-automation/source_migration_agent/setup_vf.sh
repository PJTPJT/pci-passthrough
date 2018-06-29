#!/bin/bash

# Setup virtual function.
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

if [[ $# != 1 ]]; then
  echo "Usage: $0 <NUMBER OF VFS>"
  exit 1
fi

num_vf=$1

echo $num_vf > /sys/class/net/enp7s0f1/device/sriov_numvfs





#!/bin/bash

# Get the total number of VM exit events from the KVM profile.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  11/24/2017

# Check the command line arguments.
if [ $# -ne 1 ]; then
  echo "Usage: $0 <KVM PROFILE>"
  exit 1
fi

# Get the KVM profile.
kvm_profile=$1

# Get the event counts for VM exits.
sed -n '/kvm_exit/,/Event count/p' ${kvm_profile} | tail -n 1 | awk -F':' '{print $2}' | sed "s/[ \t]//"

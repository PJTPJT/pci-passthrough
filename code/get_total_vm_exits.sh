#!/bin/bash

# Get the total number of VM exit events from the KVM profile.

# Check the command line arguments.
if [ $# -ne 1 ]; then
  echo "Usage: $0 <KVM PROFILE>"
  exit 1
fi

# Get the KVM profile.
kvm_profile=$1

# Get the event counts for VM exits.
sed -n '/kvm_exit/,/Event count/p' ${kvm_profile} | tail -n 1 | awk -F':' '{print $2}' | sed "s/[ \t]//"

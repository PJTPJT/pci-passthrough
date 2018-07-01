#!/bin/bash

# For a given VM-exit reason, sum up its percentages.

# Get the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <VM EXIT REASON> <KVM PROFILE>"
  exit 1
fi
reason=$1
kvm_profile=$2

# Sum the percentage of VM exits 
grep -ie "${reason}" ${kvm_profile} | awk '{print $1}' | tr '%' ' ' | awk '{sum += $1} END {print sum}'

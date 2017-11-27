#!/bin/bash

# Sum the percentage of VM exits due to the particular reason.
# @author Kevin Cheng
# @since  11/23/2017

# Check the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <VM EXIT REASON> <KVM PROFILE>"
  exit 1
fi

# Get the reason.
reason=$1

# Get the KVM profile
kvm_profile=$2

# Sum the percentage of VM exits 
grep -ie "${reason}" ${kvm_profile} | awk '{print $1}' | tr '%' ' ' | awk '{sum += $1} END {print sum}'

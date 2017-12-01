#!/bin/bash

# Compute the percentage of VM exits for each reason.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  11/23/2017

# Check the command line arguments.
if [ $# -ne 1 ]; then
  echo "Usage: $0 <KVM PROFILE>"
  exit 1
fi

# Get the KVM profile.
kvm_profile=$1

# Get the block containing VM exits.
sed -n '/kvm_exit/,/kvm_inj_virq/p' ${kvm_profile} | sed -e '/#/d' -e '/^$/d' > vmexits.txt

# Get the reasons.
awk '{print $3}' vmexits.txt | sort | uniq | tail -n +2 > reasons.txt

# Compute the percentage of vm exits due to the specific reasons.
cat reasons.txt | xargs -I rsn ./sum_vm_exit_percentage_by_reason.sh rsn vmexits.txt > percentages.txt

# Construct the output
paste reasons.txt percentages.txt

# Clean up
rm vmexits.txt reasons.txt percentages.txt

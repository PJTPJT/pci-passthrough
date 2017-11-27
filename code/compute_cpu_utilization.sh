#!/bin/bash

# Compute the CPU utilization in the user and system mode from the atopsar
# output.
# @author Kevin Cheng
# @since  11/23/2017

# Check the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <TIME STAMP> <CPU UTILIZATION>"
  exit 1
fi

# Get the time stamps
timestamps=$1

# Get the cpu utilizations over time.
cpu_utilizations=$2

# Compute the user cpu utilization.
user=$(./compute_user_cpu_utilization.sh ${timestamps} ${cpu_utilizations})

# Compute the system cpu utilization.
system=$(./compute_system_cpu_utilization.sh ${timestamps} ${cpu_utilizations})

# Compute the guest cpu utilization.
guest=$(./compute_guest_cpu_utilization.sh ${timestamps} ${cpu_utilizations})

# Compute the total cpu utilization.
total=$(echo "scale=2; ${user} + ${system}" | bc)

# Print the output: user system total
echo -e "${guest}\t${user}\t${system}\t${total}"

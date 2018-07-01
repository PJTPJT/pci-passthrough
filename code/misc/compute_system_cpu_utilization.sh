#!/bin/bash

# Compute the CPU utilization used in the system mode.

# Check the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <TIME STAMP> <CPU UTILIZATION>"
  exit 1
fi

# Get the time stamps
timestamps=($(cat $1))

# Get the cpu utilizations over time.
cpu_utilizations=$2

# Extract the block, containing the experiment data.
sed -ne "/${timestamps[0]}/, /${timestamps[1]}/p" ${cpu_utilizations} | awk '{sum += $5 + $6 + $7} END {print sum/NR}'

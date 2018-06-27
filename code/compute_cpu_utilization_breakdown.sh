#!/bin/bash

# Compute the mean CPU utilization for the following fields based on the
# descriptions of atopsar manpage.
# - user.
# - nice.
# - sys.
# - irq.
# - softirq.
# - steal.
# - guest.
# - wait.
# - idle.


# Check the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <TIME STAMP> <CPU UTILIZATION>"
  exit 1
fi

# Get the time stamps
timestamps=($(cat $1))

# Get the cpu utilizations over time.
cpu_utilizations=$2

# Compute the mean cpu utilization.
sed -ne "/${timestamps[0]}/, /${timestamps[1]}/p" ${cpu_utilizations} |\
awk '{user+=$3; nice+=$4; sys+=$5; irq+=$6; softirq+=$7; steal+=$8; guest+=$9; wait+=$10; idle+=$11} END {printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" ,user/NR, nice/NR, sys/NR, irq/NR, softirq/NR, steal/NR, guest/NR, wait/NR, idle/NR)}'


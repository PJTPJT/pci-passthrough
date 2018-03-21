#!/bin/bash

# Get the clock rate for N seconds.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  12/30/2017

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <SECONDS>"
  exit
fi

# Get the number of seconds.
seconds=$1

# Get the cpu clock rate.
for i in $(seq 1 ${seconds}); do
  grep -ie 'mhz' /proc/cpuinfo
  sleep ${seconds}
done

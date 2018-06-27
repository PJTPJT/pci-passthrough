#!/bin/bash

# Get the clock rate for N seconds.

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

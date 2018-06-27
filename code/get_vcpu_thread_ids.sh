#!/bin/bash

# Extract vCPU thread ID(s) from the QMP.

# Check the command line arguments.
if [ $# -ne 1 ]; then
  echo "Usage: $0 <UNIX SOCKET>"
  exit
fi

# Extract the vCPU thread IDs.
socket=$1
echo '{"execute":"qmp_capabilities"}{"execute":"query-cpus"}' |\
nc -U ${socket} | tail -n 1 | tr ',{}[]' '\n' |\
awk '/thread_id/ {print $2}'

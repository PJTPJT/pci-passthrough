#!/bin/bash

# Migrate the VM.

# Get the command line arguments.
if [[ $# != 3 ]]; then
  echo "Usage: $0 <DESTINATION IP> <PORT> <SOCKET>"
  exit 1
fi
dest=$1
port=$2
socket=$3

# VM live migration.
echo "{\"execute\": \"qmp_capabilities\"} {\"execute\": \"migrate\", \"arguments\": {\"uri\":\"tcp:${dest}:${port}\"}}" | nc -U "${socket}"

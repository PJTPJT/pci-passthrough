#!/bin/bash

# Start the precopy VM migration.

if [[ $# != 3 ]]; then
  echo "Usage: $0 <DESTINATION IP> <PORT> <SOCKET>"
  exit 1
fi

# Destination parameters.
dest=$1
port=$2
socket=$3
echo "{\"execute\": \"qmp_capabilities\"} {\"execute\": \"migrate\", \"arguments\": {\"uri\":\"tcp:${dest}:${port}\"}}" | nc -U "${socket}"

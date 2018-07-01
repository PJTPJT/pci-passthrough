#!/bin/bash

# Start the precopy VM migration.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/03/2018

if [[ $# != 3 ]]; then
  echo "Usage: $0 <DESTINATION IP> <PORT> <SOCKET>"
  exit 1
fi

# Destination parameters.
dest=$1
port=$2
socket=$3
echo "{\"execute\": \"qmp_capabilities\"} {\"execute\": \"migrate\", \"arguments\": {\"uri\":\"tcp:${dest}:${port}\"}}" | nc -U "${socket}"

#!/bin/bash

# Check the migration status.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/03/2018

# Input parameters.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <SOCKET>"
  exit 1
fi
socket=$1
echo '{"execute": "qmp_capabilities"} {"execute": "query-migrate"}' | nc -U "${socket}"

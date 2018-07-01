#!/bin/bash

# Switch vfio nic.
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/03/2018

if [[ $# != 2 ]]; then
  echo "Usage: $0 <DESTINATION IP ADDRESS> <PORT>"
  exit 1
fi

destination_IP_address=$1
port=$2

# Unplug NIC 
bash hot_switch_vfio_nic.sh unplug

# Migrate the VM
bash migrate.sh $destination_IP_address $port /tmp/qmp-socket

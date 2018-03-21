#!/bin/bash

# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  12/25/2017

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <CPU>"
  exit
fi

pcpu=$1
taskset -c ${pcpu} cat /proc/write_vmcs_control_fields
echo "VMCS control fields are updated."
#echo "-------------------------------------------------"
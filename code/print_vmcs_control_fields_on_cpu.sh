#!/bin/bash


if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <CPU>"
  exit
fi

pcpu=$1
taskset -c ${pcpu} cat /proc/vmcs_control_field
echo "-------------------------------------------------"

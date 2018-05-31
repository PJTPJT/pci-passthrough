#!/bin/bash

# Hot plug/unplug the passthrough NIC.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  04/02/2018

# Display the usage message.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <MODE>"
  echo "MODE: plug or unplug."
  exit 1
fi
switch=$1

if [[ "${switch}" == 'plug' ]]; then
  echo "0000:07:10.1" > /sys/bus/pci/drivers/vfio-pci/bind
  ls -l /sys/bus/pci/drivers/vfio-pci/
  echo '{"execute":"qmp_capabilities"}{"execute":"device_add","arguments":{"driver":"vfio-pci","host":"07:10.1","id":"assigned_nic"}}' | nc -U /tmp/qmp-socket
elif [[ "${switch}" == 'unplug' ]]; then
  echo '{"execute":"qmp_capabilities"}{"execute":"device_del","arguments":{"id":"assigned_nic"}}' | nc -U /tmp/qmp-socket
  echo "0000:07:10.1" > /sys/bus/pci/drivers/vfio-pci/unbind
  ip link | grep -i vf
  ls -l /sys/bus/pci/drivers/vfio-pci/
fi

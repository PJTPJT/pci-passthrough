#!/bin/bash

# Hot plug/unplug the passthrough NIC.

# Display the usage message.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <MODE>"
  echo "MODE: plug or unplug."
  exit 1
fi
switch=$1

if [[ "${switch}" == 'plug' ]]; then
  echo "0000:07:00.1" > /sys/bus/pci/drivers/igb/unbind
  echo "0000:07:00.1" > /sys/bus/pci/drivers/vfio-pci/bind
  ls -l /sys/bus/pci/drivers/vfio-pci/
  echo '{"execute":"qmp_capabilities"}{"execute":"device_add","arguments":{"driver":"vfio-pci","host":"07:00.1","id":"assigned_nic"}}' | nc -U /tmp/qmp-socket
elif [[ "${switch}" == 'unplug' ]]; then
  echo '{"execute":"qmp_capabilities"}{"execute":"device_del","arguments":{"id":"assigned_nic"}}' | nc -U /tmp/qmp-socket
  echo "0000:07:00.1" > /sys/bus/pci/drivers/vfio-pci/unbind
  echo "0000:07:00.1" > /sys/bus/pci/drivers/igb/bind
  ls -l /sys/bus/pci/drivers/vfio-pci/
fi

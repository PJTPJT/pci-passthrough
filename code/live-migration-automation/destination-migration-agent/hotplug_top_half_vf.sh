#!/bin/bash

socket="/tmp/qmp-socket"

echo '{"execute": "qmp_capabilities"} {"execute": "osnet-vfio-nic-create", "arguments": {"driver": "vfio-pci", "id": "assigned_nic", "host": "07:10.1"} }' | nc -U "${socket}" 

echo '{"execute": "qmp_capabilities"} {"execute": "osnet-vfio-nic-realize-top-half", "arguments": {"id": "assigned_nic"} }' | nc -U "${socket}" 

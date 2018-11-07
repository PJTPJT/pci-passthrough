#!/bin/bash

socket="/tmp/qmp-socket"

echo '{"execute": "qmp_capabilities"} {"execute": "osnet-vfio-nic-realize-bottom-half", "arguments": {"id": "assigned_nic"} }' | nc -U "${socket}" 

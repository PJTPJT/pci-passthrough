#!/bin/bash

# Boot up the VM with the VFIO NIC and VFIO SSD. The VM disk
# is the VFIO SSD.

# Get the input arguments.
if [[ $# != 4 ]]; then
  echo "Usage: $0 <VCPU> <MEMORY> <NIC BDF> <HD BDF>"
  exit 1
fi
vcpu=$1
memory=$2
nic_bdf=$3
hd_bdf=$4

# Boot up the VM.
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp ${vcpu} \
                   -m   ${memory} \
                   -device vfio-pci,host=${hd_bdf},id=assigned_sata \
                   -net none \
                   -device vfio-pci,host=${nic_bdf},id=vfio_pci_nic \
                   -nographic \
                   -monitor none \
                   -parallel none \
                   -serial none \
                   -qmp unix:/tmp/qmp-socket,server,nowait

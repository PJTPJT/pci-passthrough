#!/bin/bash

# We switch the control of host network interface card (NIC) from the hypervisor
# to the VM. We have only experimented  with this script on my desktop machine,
# d15.
# @author - Kevin Cheng
# @since  - 06/04/2017

# Compute the elapsed time from the start and stop time.
ComputeElapsedTime() {
  local start=$1
  local end=$2
  echo ${start}
  echo ${end}
  echo $((end - start))
}

# ID of Network interface card.
nic_id="0000:00:1f.6"

# Vendor ID and device type.
nic_vendor_info="8086 15b7"

# Location of drivers on the host.
pci_driver_location="/sys/bus/pci/drivers"

# Default host ethernet driver.
default_nic_driver="e1000e"

# VFIO PCI driver for the VM
vfio="vfio-pci"

# NIC name
nic_name="enp0s31f6"

# We use the Google public DNS to test the HTTPS connection.
google_public_dns="8.8.8.8 443"

# Unbind the host's network interface card from the hypervisor.
#start_time=$(date +%s%6N)
date +%s%6N
echo ${nic_id} > "${pci_driver_location}/${default_nic_driver}/unbind"

# Wait until the network interface is down.
while ifconfig ${nic_name} &> /dev/null; do :; done;
#stop_time=$(date +%s%6N)
#ComputeElapsedTime ${start_time} ${stop_time}

################################################################################
# WARNING: we need to start the VM without a network connection and communicate
# with the QEMU monitor through the Unix domain socket.
################################################################################

# Bind the host network interface card to the vfio driver.
#start_time=$(date +%s%6N)
echo ${nic_vendor_info} > "${pci_driver_location}/${vfio}/new_id"
echo ${nic_id} > "${pci_driver_location}/${vfio}/bind"

# Hot plug the network interface card to the VM via the qemu monitor.
echo '{ "execute": "qmp_capabilities"} {"execute": "device_add", "arguments": {"driver": "vfio-pci", "host": "00:1f.6", "id": "kevin"}}'\
     | nc -U /tmp/qmp-socket &> /dev/null
#stop_time=$(date +%s%6N)
#ComputeElapsedTime ${start_time} ${stop_time}

# Wait for n seconds.
sleep 1

# Hot unplug the network interface card from the VM via the qemu monitor.
echo '{ "execute": "qmp_capabilities"} {"execute": "device_del", "arguments": {"id": "kevin"}}'\
     | nc -U /tmp/qmp-socket &> /dev/null

# Unbind he host network interface card from the vfio driver.
#start_time=$(date +%s%6N)
echo ${nic_id} > "${pci_driver_location}/${vfio}/unbind"
echo ${nic_vendor_info} > "${pci_driver_location}/${vfio}/remove_id"
#stop_time=$(date +%s%6N)
#ComputeElapsedTime ${start_time} ${stop_time}

## Bind the network interface card to the hypervisor.
#start_time=$(date +%s%6N)
echo ${nic_id} > "${pci_driver_location}/${default_nic_driver}/bind"

# Wait until the network interface is up.
while ! ifconfig ${nic_name} &> /dev/null; do :; done;
date +%s%6N
#stop_time=$(date +%s%6N)
#ComputeElapsedTime ${start_time} ${stop_time}

## Wait until there is a HTTPS connection.
#start_time=$(date +%s%6N)
#while ! nc -z ${google_public_dns}; do :; done
#stop_time=$(date +%s%6N)
#ComputeElapsedTime ${start_time} ${stop_time}

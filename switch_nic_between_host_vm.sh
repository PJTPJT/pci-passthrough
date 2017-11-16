#!/bin/bash

# We switch the control of host network interface card (NIC) from the hypervisor
# to the VM.
# @author - Kevin Cheng
# @since  - 11/15/2017

# Compute the elapsed time from the start and stop time.
ComputeElapsedTime() {
  local start=$1
  local end=$2
  #echo ${start}
  #echo ${end}
  echo $((end - start))
}

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: ./$0 <NIC DEVICE ID> <VENDOR ID>" 1>&2
  exit 1
fi

# Process the command line arguments.
nic_id="0000:$1"
nic_vendor_id=$(echo $2 | tr ':' ' ')

# Get the host NIC driver.
host_nic_driver=$(ls -l "/sys/bus/pci/devices/${nic_id}/driver" | awk -F'/' '{print $NF}')

# We use the Google public DNS to test the HTTPS connection.
google_public_dns="8.8.8.8 443"

# Start the microsecond timer.
start_time=$(date +%s%6N)

# Unbind the host's network interface card from the hypervisor.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/unbind"

# Wait until there is an internet connection.
while ! nc -vz ${google_public_dns}; do :; done

###################################################################
# WARNING: we have started the VM without a network connection and
# communicate with the QEMU monitor through the Unix domain socket.
###################################################################

# Bind the host network interface card to the vfio driver.
echo "${nic_vendor_id}" > "/sys/bus/pci/drivers/vfio-pci/new_id"
echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/bind"

# Hot plug the network interface card to the VM via the qemu monitor.
echo "{ "execute": "qmp_capabilities"} {"execute": "device_add", "arguments": {"driver": "vfio-pci", "host": "${nic_id}", "id": "pnic"}}" \
     | nc -U /tmp/qmp-socket &> /dev/null

# Wait for n seconds.
sleep 1

# Hot unplug the network interface card from the VM via the qemu monitor.
echo '{ "execute": "qmp_capabilities"} {"execute": "device_del", "arguments": {"id": "kevin"}}'\
     | nc -U /tmp/qmp-socket &> /dev/null

# Unbind the host network interface card from the vfio driver.
#start_time=$(date +%s%6N)
echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/unbind"
echo ${nic_vendor_id} > "/sys/bus/pci/drivers/vfio-pci/remove_id"

# Bind the network interface card to the hypervisor.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

# Wait until there is an internet connection.
while ! nc -vz ${google_public_dns}; do :; done

# Stop the microsecond timer.
stop_time=$(date +%s%6N)

# Compute the switch time in microseconds.
elapsed_time=$(ComputeElapsedTime ${start_time} ${stop_time})
elapsed_time=$((elapsed_time - 1000000));
echo ${elapsed_time}

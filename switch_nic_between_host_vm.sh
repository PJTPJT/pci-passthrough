#!/bin/bash

# We switch the control of host network interface card (NIC) from the
# hypervisor to the VM.
# Assume the VFIO modules are loaded.
# @author - Kevin Cheng
# @since  - 11/15/2017

###################################################################
# WARNING: we need to start the VM without a network connection and
# communicate with the QEMU monitor through the Unix domain socket.
# Please see "run_vm_qmp_no_network.sh".
###################################################################

# Compute the elapsed time from the start and stop time.
ComputeElapsedTime() {
  local start=$1
  local end=$2
  echo $((end - start))
}

# Check on the input arguments.
# NET INTERFACE is the name of network interface obtained from
# "ifconfig".
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <NIC DEVICE ID> <VENDOR ID> <NET INTERFACE>" 1>&2
  exit 1
fi

# Check if VFIO modules are loaded.
if [[ ! -d "/sys/bus/pci/drivers/vfio-pci" ]]; then
  echo "ERROR: Please load VFIO modules." 1>&2
  exit 2
fi

# Process the command line arguments.
nic_id="0000:$1"
nic_vendor_id=$(echo $2 | tr ':' ' ')
nic_name=$3

# Get the host NIC driver.
host_nic_driver=$(ls -l "/sys/bus/pci/devices/${nic_id}/driver" | awk -F'/' '{print $NF}')

# We use the Google public DNS to test the HTTPS connection.
#google_public_dns="8.8.8.8 443"

# Start the microsecond timer.
start_time=$(date +%s%6N)

# Unbind the host's network interface card from the hypervisor.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/unbind"

# Wait until there is no internet connection.
#while nc -vz ${google_public_dns} &> /dev/null; do :; done
while ifconfig ${nic_name} &> /dev/null; do :; done;

###################################################################
# WARNING: we have started the VM without a network connection and
# communicate with the QEMU monitor through the Unix domain socket.
###################################################################

# Bind the host network interface card to the vfio driver.
echo "${nic_vendor_id}" > "/sys/bus/pci/drivers/vfio-pci/new_id"

# If binding the host NIC to vfio-pci by the NIC vendor is not
# sufficient, we can try the device ID of NIC.
#echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/bind"

# Hot plug the network interface card to the VM via the qemu monitor.
echo "{ "execute": "qmp_capabilities"} {"execute": "device_add", "arguments": {"driver": "vfio-pci", "host": "${nic_id}", "id": "pnic"}}" \
     | nc -U /tmp/qmp-socket &> /dev/null

# Wait for n seconds.
sleep 1

# Hot unplug the network interface card from the VM via the qemu monitor.
echo '{ "execute": "qmp_capabilities"} {"execute": "device_del", "arguments": {"id": "pnic"}}'\
     | nc -U /tmp/qmp-socket &> /dev/null

# Unbind the host network interface card from the vfio driver.
#start_time=$(date +%s%6N)
echo "${nic_id}" > "/sys/bus/pci/drivers/vfio-pci/unbind"
echo ${nic_vendor_id} > "/sys/bus/pci/drivers/vfio-pci/remove_id"

# Bind the network interface card to the hypervisor.
echo "${nic_id}" > "/sys/bus/pci/drivers/${host_nic_driver}/bind"

# Wait until there is an internet connection.
#while ! nc -vz ${google_public_dns} &> /dev/null; do :; done
while ! ifconfig ${nic_name} &> /dev/null; do :; done;

# Stop the microsecond timer.
stop_time=$(date +%s%6N)

# Compute the switch time in microseconds.
elapsed_time=$(ComputeElapsedTime ${start_time} ${stop_time})
echo ${elapsed_time}
elapsed_time=$((elapsed_time - 1000000));
echo ${elapsed_time}

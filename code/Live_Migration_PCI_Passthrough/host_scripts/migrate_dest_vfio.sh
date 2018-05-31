#!/bin/bash
if [[ $# != 3 ]]; then
  echo "Usage: $0 <NUMBER OF VCPUs> <VM MEMORY SIZE> <VM IMAGE PATH> "
  exit 1
fi

vcpu=$1
memory=$2
path=$3
timetracker=10.128.0.50
interface=enp7s0f1
vf_index=0
mac_addr=00:25:90:d8:aa:ee
num_of_vfs=1

#setup virtual function
./setup_vf.sh $num_of_vfs
sleep 1

#set mac for Virtual functiom
./set_mac.sh $interface $vf_index $mac_addr
sleep 1

#Unbind VF from igb and bind it to vfio 
./setup_vfio_nic.sh

#start VM wihh virtio
./run_vm_at_destination.sh $vcpu $memory $path & 

#wait for the migration to complete
./waitserver 3333 1

sleep 5

#unplug the vfio and bing to host
./hot_switch_vfio_nic.sh plug
sleep 5

sshpass -p root ssh root@10.128.33.11 "./setup_dest_bonding_driver.sh"
echo "Done"


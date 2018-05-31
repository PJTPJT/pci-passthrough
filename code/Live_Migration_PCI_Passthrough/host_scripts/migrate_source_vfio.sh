#!/bin/bash

if [[ $# != 5 ]]; then
  echo "Usage: $0 <NUMBER OF VCPUs> <VM MEMORY SIZE> <VM IMAGE PATH> <DESTINATION IP> <PORT>"
  exit 1
fi

vcpu=$1
memory=$2
path=$3
destIP=$4
port=$5
timetracker=10.128.0.50
interface=enp7s0f1
vf_index=0
mac_addr=00:25:90:d8:aa:ee
num_of_vfs=1


#setup virtual function
./setup_vf.sh $num_of_vfs
sleep 1

#Set up mac for virtual function
./set_mac.sh $interface $vf_index $mac_addr
sleep 1

#unbing VF and bing to vfio
./setup_vfio_nic.sh
sleep 2

#start VM wihh virtio
./run_vm_nic_bonding.sh $vcpu $memory $path & #/shared/ubuntu_16_nic_bonding.img &
sleep 100 # VM works normally for 100 sec
#while ! nc -vz 10.128.7.7 22 &> /dev/null; do :; done

sshpass -p root ssh root@10.128.33.11 "./setup_migration_env.sh"

#unplug the vfio and bing to host
./hot_switch_vfio_nic.sh unplug
sleep 1

#wait till the network is back
#while ! nc -vz 10.128.33.11 22 &> /dev/null; do :; done

#migrate
./migrate.sh $destIP $port /tmp/qmp-socket
sleep 1

#keep checking for migration status. Once migration completed send a packet to destination
for (( ; ; ))
do
    if (( $(./check_migration_status.sh /tmp/qmp-socket |grep complete |wc -l) == 1)) 
    then
            echo "done" > /dev/udp/$destIP/3333
            echo "migration complete"
            break
    elif (( $(./check_migration_status.sh /tmp/qmp-socket |grep failed |wc -l) == 1))
    then
            echo "migration failed"
            break
    fi
done


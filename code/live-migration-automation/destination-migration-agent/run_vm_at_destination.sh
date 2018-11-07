#!/bin/bash

# Detect if the vfio-pci has been loaded.
lsmod | grep -ie "vfio-pci" &> /dev/null
if [[ $? = 1 ]]; then
  modprobe vfio-pci
fi

sudo qemu-system-x86_64 \
	-cpu host \
	-smp 1 \
	-m 2048 \
  -drive file=/root/spoorti/vm-images/c3po.qcow2 \
	--enable-kvm \
	-netdev tap,ifname=qtap0,id=mytap,vhost=on \
	-device virtio-net,netdev=mytap \
	-qmp unix:/tmp/qmp-socket,server,nowait \
	-incoming tcp:0:1111 \
  -net none \
	-display none \
	-monitor telnet:127.0.0.1:5555,server,nowait \
	-serial telnet:127.0.0.1:2222,server,nowait 

  #-object iothread,id=iothread0 \
  #-drive if=none,file=/root/ubuntu_16_nic_bonding_dest.img,format=raw,id=drive0,cache=writeback,aio=threads \
  #-device virtio-blk,iothread=iothread0,drive=drive0 \
	#-net none 
	#-drive file=/root/spoorti/vm-images/c3po.qcow2,if=virtio \
	#-net none 
	#-device vfio-pci,host=07:10.1,id=assigned_nic \
	#-net tap,ifname=qtap0,script=no,downscript=no \
	#-net nic,model=virtio,macaddr=60:06:19:19:76:97 \


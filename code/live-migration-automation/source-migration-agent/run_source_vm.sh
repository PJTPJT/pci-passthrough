#!/bin/bash

#./addtap.sh 0

sudo ./setup_vfio_nic.sh

sudo qemu-system-x86_64 \
	-drive file=/home/spoorti/vm-images/c3po.qcow2 \
	-m 2048 \
	-smp 1 \
	--enable-kvm \
	-display none \
	-cpu host \
	-monitor telnet:127.0.0.1:8888,server,nowait \
	-serial telnet:127.0.0.1:9999,server,nowait \
	-qmp unix:/tmp/qmp-socket,server,nowait \
	-device virtio-net,netdev=mytap \
	-netdev tap,ifname=qtap0,id=mytap,vhost=on \
	-net none \
	-device vfio-pci,host=07:10.1,id=assigned_nic

#	-drive file=/home/spoorti/vm-images/c3po.qcow2,if=virtio \
	#-net none 
	#-net tap,ifname=qtap0,script=no,downscript=no \
	#-net nic,model=virtio,macaddr=60:06:19:19:76:97 \

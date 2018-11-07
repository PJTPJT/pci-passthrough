#!/bin/bash

for (( ; ; ))
do
	if (( $(cat /sys/class/net/bond0/bonding/slaves | grep ens4 | wc -l) == 1))
	then
		ifenslave -c bond0 ens4
		#ping -c 1 10.128.0.43 > /dev/null
		#ping -c 1 10.128.0.41 > /dev/null
		arping -c 1 -P -U 10.128.255.255 -s c6:02:86:4a:76:54 > /dev/null 
		break
	fi
done

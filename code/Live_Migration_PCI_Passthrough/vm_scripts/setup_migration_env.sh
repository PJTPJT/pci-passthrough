#!/bin/bash

echo "-ens5" >"/sys/class/net/bond0/bonding/slaves"; ifconfig bond0 hw ether 52:54:00:12:34:56

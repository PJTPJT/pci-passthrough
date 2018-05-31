#!/bin/bash

/sbin/modprobe bonding mode=1
/sbin/ifenslave bond0 ens5 ens4

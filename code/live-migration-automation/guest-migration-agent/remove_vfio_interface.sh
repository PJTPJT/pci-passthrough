#!/bin/bash

# Check the migration status.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

sudo ifenslave -c bond0 ens3
echo "-ens4" >"/sys/class/net/bond0/bonding/slaves"; 
ifconfig ens4 down

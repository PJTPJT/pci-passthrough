#!/bin/bash

# Check the migration status.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

ifconfig bond0 hw ether 00:25:90:d8:aa:ee; 
ifenslave bond0 ens5; 
ifenslave -c bond0 ens5


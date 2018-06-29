#!/bin/bash

# Check the migration status.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

/sbin/modprobe bonding mode=1
/sbin/ifenslave bond0 ens5 ens4

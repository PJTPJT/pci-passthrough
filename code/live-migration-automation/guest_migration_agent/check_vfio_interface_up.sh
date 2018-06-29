#!/bin/bash

# Check if vfio interface is up.
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018


for (( ; ; ))
do
  if (( $(ls -l /sys/class/net/ | grep ens5 | wc -l) == 1 ))
  then
     #echo "interface recognized"
     for (( ; ; ))
     do
        if (( $(cat /sys/class/net/ens5/operstate | grep up | wc -l) == 1 ))
        then
          #echo "interface up"
          break
        fi
     done
     break
  fi 
done


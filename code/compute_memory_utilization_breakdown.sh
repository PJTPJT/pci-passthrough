#!/bin/bash

# Compute the mean memory utilization for the following fields based on the
# descriptions of atopsar manpage.
# - memtotal    Total usable main memory size.
# - memfree     Available main memory size at this moment (snapshot).
# - buffers     Main memory used at this moment to cache metadata-blocks (snapshot).
# - cached      Main memory used at this moment to cache data-blocks (snapshot).
# - dirty       Amount of memory in the page cache that still has to be flushed to disk at this moment (snapshot).
# - slabmem     Main memory used at this moment for dynamically allocated memory by the kernel (snapshot).
# - swptotal    Total swap space size at this moment (snapshot).
# - swpfree     Available swap space at this moment (snapshot).
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  01/09/2018

# Check the command line arguments.
if [ $# -ne 2 ]; then
  echo "Usage: $0 <TIME STAMP> <MEMORY UTILIZATION>"
  exit 1
fi

# Get the time stamps
timestamps=($(cat $1))

# Get the memory utilizations over time.
memory_utilizations=$2

# Compute the mean memory utilization.
for i in {0..2}; do
  begin=$(( 2 * i ))
  end=$(( 2 * i + 1 ))
  sed -ne "/${timestamps[${begin}]}/, /${timestamps[${end}]}/p" ${memory_utilizations} |\
  awk '{memtotal+=$2; memfree+=$3; buffers+=$4; cached+=$5; dirty+=$6; slabmem+=$7; swaptotal+=$8; swapfree+=$9;} END {printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", memtotal/NR, memfree/NR, buffers/NR, cached/NR, dirty/NR, slabmem/NR, swaptotal/NR, swapfree/NR)}'
done

# After the experiment, compute the mean of available memory.
last=$(( ${#timestamps[@]} - 1 ))
sed -ne "/${timestamps[${last}]}/,//p" ${memory_utilizations} | tail -n +2 |\
awk '{memtotal+=$2; memfree+=$3; buffers+=$4; cached+=$5; dirty+=$6; slabmem+=$7; swaptotal+=$8; swapfree+=$9;} END {printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", memtotal/NR, memfree/NR, buffers/NR, cached/NR, dirty/NR, slabmem/NR, swaptotal/NR, swapfree/NR)}'

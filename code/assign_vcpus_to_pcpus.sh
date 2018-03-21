#!/bin/bash

# TODO
# Need to generalize the script for assigning multiple vCPUs
# to multiple physical cores. Now, we assign the vCPU thread
# to the physical core 1 and the rest of QEMU threads to the
# core 0.

# Assign the vCPU thread to its dedicated core, while the rest
# of QEMU threads are assigned to another core.
# 
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  01/28/2018

# Get the QEMU PID.
qemu_pid=$(pgrep qemu)

# Get the QEMU thread IDs.
qemu_tid=($(ls /proc/${qemu_pid}/task))

# Get the vCPU thread ID.
vcpu_tid=$(./get_vcpu_thread_ids.sh /tmp/qmp-socket)

# Suspend the guest.
kill -SIGSTOP ${qemu_pid}

# Assign the vCPU to the core 1.
taskset -p 002 ${vcpu_tid}

# Assign the rest of QEMU threads to the core 0.
for tid in ${qemu_tid[@]}; do
  if [ ${tid} -ne ${vcpu_tid} ]; then
    taskset -p 001 ${tid}
  fi
done

# Resume the guest
kill -SIGCONT ${qemu_pid}

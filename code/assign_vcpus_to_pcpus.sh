#!/bin/bash

# Assume the VM has only one vCPU.
# Assign the vCPU thread to core 1 and the QEMU threads to
# core 0.

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

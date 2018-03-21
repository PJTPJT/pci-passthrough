#!/bin/bash

# Measure the memory footprint of KVM hypervisor.
# - Boot up a physical machine.
# - Record the memory usage of idle system for 2 min.
# - Wait for 10 seconds to let the system idle.
# - Insert the KVM modules: kvm and kvm_intel.
# - Record the memory usage of KVM hypervisor for 1 min.
# - Wait for 10 seconds to let the system idle.
# - Boot up a VM.
# - Record the memory usage of KVM hypervisor and VM for 1 min.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  01/08/2018

# Start to record the memory usage in the background.
atopsar -m 1 > memory_utilization.txt &
atopsar_pid=$!

# Wait until the system is (hypothetically) idle.
sleep 30

# Record the memory usage of idle system.
clock_in=$(date +%H:%M:%S)
sleep 60
clock_out=$(date +%H:%M:%S)
echo "${clock_in} ${clock_out}" > timestamp.txt

# Let the system idle.
sleep 10

# Record the memory usage of KVM hypervisor.
clock_in=$(date +%H:%M:%S)
modprobe kvm
modprobe kvm_intel
sleep 60
clock_out=$(date +%H:%M:%S)
echo "${clock_in} ${clock_out}" >> timestamp.txt
 
# Let the system idle.
sleep 10

# Record the memory usage of KVM hypervisor and guest.
clock_in=$(date +%H:%M:%S)
qemu-system-x86_64 -enable-kvm \
                   -cpu host \
                   -smp 1 \
                   -m 2048 \
                   -hda ubuntu_server_16p04p3.qcow2 \
                   -net none \
                   -serial none \
                   -parallel none \
                   -display none \
                   -monitor none &
vm_pid=$!
sleep 60
kill -SIGTERM ${vm_pid}
clock_out=$(date +%H:%M:%S)
echo "${clock_in} ${clock_out}" >> timestamp.txt

# Let the system idle.
sleep 60

# Stop recording to memory usage.
kill -SIGKILL ${atopsar_pid}

# Unloading the KVM modules.
rmmod kvm_intel
rmmod kvm
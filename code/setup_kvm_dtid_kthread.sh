#!/bin/bash

# Set up the KVM modules for the DTID kthread implementation.

# Unload kvm_intel and kvm.
modprobe -r kvm_intel

# Load kvm.
modprobe kvm halt_poll_ns=0 osnet_create_dtid_thread=1 osnet_timeout_jiffy=1

# KVM intel
modprobe kvm_intel preemption_timer=0 osnet_enable_hlt_exiting=0

# Display the current experiment settings.
echo "/***** kvm *****/"
echo -n 'halt_poll_ns = '; cat /sys/module/kvm/parameters/halt_poll_ns
echo -n 'osnet_create_dtid_thread = '; cat /sys/module/kvm/parameters/osnet_create_dtid_thread
echo -n 'osnset_enable_set_pir = '; cat /sys/module/kvm/parameters/osnet_enable_set_pir
echo -n 'osnet_timeout_jiffy = '; cat /sys/module/kvm/parameters/osnet_timeout_jiffy
echo -n 'osnet_dtid_thread_busy_loop = '; cat /sys/module/kvm/parameters/osnet_dtid_thread_busy_loop
echo -n 'osnet_delay_ms = '; cat /sys/module/kvm/parameters/osnet_delay_ms

echo -e "\n/***** kvm_intel *****/"
echo -n 'enable_apicv = '; cat /sys/module/kvm_intel/parameters/enable_apicv
echo -n 'preemption_timer = '; cat /sys/module/kvm_intel/parameters/preemption_timer
echo -n 'osnet_enable_hlt_exiting = '; cat /sys/module/kvm_intel/parameters/osnet_enable_hlt_exiting

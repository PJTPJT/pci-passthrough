#!/bin/bash

# Set up the KVM modules for the DTID LAPIC implementation.

# Unload kvm_intel and kvm.
modprobe -r kvm_intel

# Load kvm.
modprobe kvm halt_poll_ns=0

# KVM intel
modprobe kvm_intel preemption_timer=0 osnet_enable_hlt_exiting=1

# Display the current experiment settings.
echo "/***** kvm *****/"
echo -n 'halt_poll_ns = '; cat /sys/module/kvm/parameters/halt_poll_ns

echo -e "\n/***** kvm_intel *****/"
echo -n 'enable_apicv = '; cat /sys/module/kvm_intel/parameters/enable_apicv
echo -n 'preemption_timer = '; cat /sys/module/kvm_intel/parameters/preemption_timer
echo -n 'osnet_enable_hlt_exiting = '; cat /sys/module/kvm_intel/parameters/osnet_enable_hlt_exiting
echo -n 'osnet_enable_set_pir = '; cat /sys/module/kvm_intel/parameters/osnet_enable_set_pir


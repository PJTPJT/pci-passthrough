#!/bin/bash

# Set up the DTID B environment. DTID B uses the timer
# interrupt handler to set the PIR and ON bit.

# Display the usage message.
usage() {
  echo "Usage: $0 [-k <enable|disable>] [-c <int>] [-l <int>]" 1>&2
  echo '-k: KVM is enabled or disabled.'
  echo '-c: Number of online CPUs.'
  echo '-l: Last core.'
}

# Set the default values.
kvm='enable'
ncpus='1'
last_core='11'

# Get the command line parameters.
while getopts "k:c:l:" opt; do
  case "${opt}" in
    k) kvm="${OPTARG}" ;;
    c) ncpus="${OPTARG}" ;;
    l) last_core=${OPTARG} ;;
    :) echo "-${OPTARG} requires an argument."; exit 1 ;;
    *) usage; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Tear down the CPUs.
seq ${ncpus} ${last_core} | xargs -I NUM echo "echo 0 > /sys/devices/system/cpu/cpuNUM/online" | bash

# Update the scaling governor to the performance mode instead
# of powersave mode.
echo 'performance' > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 'performance' > /sys/devices/system/cpu/cpufreq/policy1/scaling_governor

# Get ready to lock up the CPU and disable the NMI watchdog.
echo 0 > /proc/sys/kernel/nmi_watchdog

# Enable/Disable KVM.
if [[ "${kvm}" == "disable" ]]; then
  modprobe -r kvm_intel
  if [[ $? -ne 0 ]]; then exit -1; fi
elif [[ "${kvm}" == 'enable' ]]; then
  ./setup_kvm_dtid_lapic.sh
fi

# Display the current experiment settings.
lscpu
free -h
lsmod | grep -i 'kvm'
lsmod | grep -i 'vfio'
dmesg | grep -i 'dmar'
cat /proc/interrupts
echo -n 'halt_poll_ns = '; cat /sys/module/kvm/parameters/halt_poll_ns
echo -n 'kvmclock_periodic_sync = '; cat /sys/module/kvm/parameters/kvmclock_periodic_sync
echo -n 'enable_apicv = '; cat /sys/module/kvm_intel/parameters/enable_apicv
echo -n 'osnet_enable_hlt_exiting = '; cat /sys/module/kvm_intel/parameters/osnet_enable_hlt_exiting
echo -n 'preemption_timer = '; cat /sys/module/kvm_intel/parameters/preemption_timer
echo -n 'osnet_enable_set_pir = '; cat /sys/module/kvm_intel/parameters/osnet_enable_set_pir

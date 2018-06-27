#!/bin/bash

# TODO
# Need to generalize the algorithm to assign some IRQs to some
# cores. Right now, we assigned all the IRQs to physical core
# 0, while the guest was running on the core 1.

# Assign the IRQs to physical cores.

# The default IRQ affinity 
echo 001 > /proc/irq/default_smp_affinity

# Assign the IRQs to the physical core 0.
find /proc/irq -name 'smp_affinity' | xargs -I IRQ echo "echo 001 > IRQ" | bash

# Display IRQ affinities.
echo -n '/proc/irq/default_smp_affinity: '
cat /proc/irq/default_smp_affinity
echo '/proc/irq/*/smp_affinity:'
cat /proc/irq/*/smp_affinity

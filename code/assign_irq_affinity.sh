#!/bin/bash

# Assign all the IRQs to the core 0.

# Update the the default IRQ affinity to the core 0.
echo 001 > /proc/irq/default_smp_affinity

# Assign the IRQs to the physical core 0.
find /proc/irq -name 'smp_affinity' | xargs -I IRQ echo "echo 001 > IRQ" | bash

# Display the IRQ affinities.
echo -n '/proc/irq/default_smp_affinity: '
cat /proc/irq/default_smp_affinity
echo '/proc/irq/*/smp_affinity:'
cat /proc/irq/*/smp_affinity

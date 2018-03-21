#!/bin/bash

# TODO
# Need to define the default IRQ affinities first.

# Restore the IRQ affinities.
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  01/28/2018

# IRQ is assigned to every possible core.
default="3ff"

# Restore the default IRQ affinity.
echo ${default} > /proc/irq/default_smp_affinity

# Restore the IRQ affinities.
find /proc/irq -name 'smp_affinity' | xargs -I IRQ echo "echo ${default} > IRQ" | bash

# Display IRQ affinities.
echo -n '/proc/irq/default_smp_affinity: '
cat /proc/irq/default_smp_affinity
echo '/proc/irq/*/smp_affinity:'
cat /proc/irq/*/smp_affinity

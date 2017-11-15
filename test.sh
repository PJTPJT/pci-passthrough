#!/bin/bash

# Perform the integration test.
# @author Kevin Cheng
# @since  11/15/2017

# Get the devie and vendor ID.

# VM has the control of physical network card through the VFIO.
#./setup_vfio_pci_nic.sh

sleep 10

# Host has the control of physical network card.
#restore_from_vfio_pci_nic.sh


tree /sys/bus/pci/drivers/vfio-pci
tree /sys/bus/pci/drivers/igb

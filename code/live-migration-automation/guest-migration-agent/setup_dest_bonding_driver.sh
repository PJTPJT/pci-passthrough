#!/bin/bash

ifenslave bond0 ens4
./check_vfio_interface_enslaved.sh

#!/bin/bash

ifconfig bond0 hw ether 00:25:90:d8:aa:ee; ifenslave bond0 ens5; ifenslave -c bond0 ens5


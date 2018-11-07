#!/bin/bash

# Check the migration status.
# @author Spoorti Doddamani (sdoddam1@binghamton.edu)
# @author Kevin Cheng       (tcheng8@binghamton.edu)
# @author Aprameya Bhat     (abhat3@binghamton.edu)
# @author Kartik Gopalan    (kartik@binghamton.edu)
# @since  06/29/2018

for (( ;; ))
do
	echo '{"execute": "qmp_capabilities"} {"execute": "query-status"}' | nc -U "/tmp/qmp-socket" 2> /dev/null
	if [[ $? -eq 0 ]]
	then
    #echo "Done preparing"
		echo -n "prepared" > /dev/tcp/10.128.0.42/3535
		#echo "inmigrate set"
		break
	fi
done

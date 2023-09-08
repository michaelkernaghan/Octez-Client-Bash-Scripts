#!/bin/bash
while true
do
    ./staking-balance-histories.sh
    sleep 65520         # Then wait 18.2 hours (18.2 hours = 65520 seconds. 
			# A cycle is approximately 8*8192=65536 seconds.
done

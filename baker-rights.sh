#!/bin/bash
# File: baker-right.sh
# Author: Michael Kernaghan
#--------------------------------------------------------------
# This script is designed to fetch the baking rights of a specific Tezos address for the current and the subsequent cycle.
#--------------------------------------------------------------

# Import common shell script functions and variables for code reuse and simplicity.
source ./common.sh

# Define the Tezos address that we are interested in. 
# This is the address whose transaction history we wish to monitor.
baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

# Change the working directory to the Tezos root directory.
cd $HOME/tezos/

# Extract the current cycle from the Tezos blockchain.
cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
echo -e "\n${COLORS[BLUE]}The current cycle on the Tezos blockchain is: ${COLORS[RED]}${cycle}${COLORS[NC]}"

# Fetch the baking rights for the current cycle for the specified Tezos address.
baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${cycle}\&delegate=${baker_address}\&max_round=0  | jq 'map({level: .level, estimated_time: .estimated_time})')
echo -e "\n${COLORS[BLUE]}The baking rights for the current cycle for the given address are at times: ${COLORS[NC]}${baking_rights}"

# Calculate the next cycle
next_cycle=$((cycle+1))
echo -e "\n${COLORS[BLUE]}The next cycle on the Tezos blockchain is: ${COLORS[RED]}${next_cycle}${COLORS[NC]}"

# Ensure that the next cycle is a natural number before making the rpc call.
if [[ "$next_cycle" =~ ^[0-9]+$ ]]
then
    # Fetch the baking rights for the next cycle for the baker Tezos address.
    next_baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${next_cycle}\&delegate=${baker_address}\&max_round=0 | jq 'map({level: .level, estimated_time: .estimated_time})')
    echo -e "\n${COLORS[BLUE]}The baking rights for the next cycle for the baker address are at times: \n${COLORS[NC]}${next_baking_rights}"
else
    echo -e "\n${COLORS[RED]}Error: The next cycle is not a natural number. Please check the script.${COLORS[NC]}"
fi
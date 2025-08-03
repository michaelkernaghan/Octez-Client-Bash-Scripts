#!/bin/bash
source ./common.sh

# Check if required tools are available
check_octez_client

# Prompt the user for the amount to transfer
read -p "Enter the amount to stake: " amount

# Iterate over the list of addresses
for address in "${staker_addresses[@]}"; do
    # Use the octez-client command to transfer tez from the address to the target address
    octez-client transfer $amount from $address to $address --entrypoint stake

    # Print a message indicating that the transfer has been initiated
    echo -e "${COLORS[GREEN]}Initiated a staking transfer of ${COLORS[NC]}$amount ${COLORS[GREEN]}from ${COLORS[YELLOW]}$address ${COLORS[GREEN]}to ${COLORS[YELLOW]}$address.${COLORS[NC]}"
done


 

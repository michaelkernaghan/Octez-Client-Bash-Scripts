#!/bin/bash
source ./common.sh

# Prompt the user for the amount to transfer
read -p "Enter the amount to stake: " amount

# Use the octez-client command to stake tez from the baker address to the baker address
octez-client transfer $amount from $baker_address to $baker_address --entrypoint stake
echo -e "${COLORS[GREEN]}Initiated a staking transfer of ${COLORS[NC]}$amount ${COLORS[GREEN]}from ${COLORS[YELLOW]}$baker_address ${COLORS[GREEN]}to ${COLORS[YELLOW]}$baker_address.${COLORS[NC]}"

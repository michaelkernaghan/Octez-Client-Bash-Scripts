#!/bin/bash
source ./common.sh

# Iterate over the list of addresses
for address in "${staker_addresses[@]}"; do
    staker_balance=$(/home/mike/tezos/octez-client get balance for "$address")
    echo -e "${COLORS[GREEN]}The balance of Staker ${COLORS[YELLOW]}$address ${COLORS[GREEN]}is ${COLORS[NC]}$staker_balance."
done

baker_balance=$(/home/mike/tezos/octez-client get balance for "$baker_address")
echo -e "${COLORS[GREEN]}The balance of Baker ${COLORS[YELLOW]}$baker_address ${COLORS[GREEN]}is ${COLORS[NC]}$baker_balance."

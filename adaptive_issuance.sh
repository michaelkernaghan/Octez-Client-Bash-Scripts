#!/bin/bash
# ----------------------------------------------------------
# adaptive_issuance.sh
# Michael Kernaghan
#-----------------------------------------------------------
# The script first disables the Tezos client disclaimer, then defines some colors for output formatting. 
# It then lists the staker addresses and the baker address, and prints the balances of the staker addresses. 
# The script then changes to the Tezos root directory, gets the current cycle, and prints it. 
# Finally, the script gets and prints the baker delegation information and the pending staking parameters.
# ----------------------------------------------------------

source ./common.sh

# Print the balances of the staker addresses
echo -e "${COLORS[BLUE]}Stakers${COLORS[NC]}"
for address in "${staker_addresses[@]}"; do
    balance=$(/home/mike/tezos/octez-client get balance for "$address")
    echo -e "${COLORS[GREEN]}The balance of ${COLORS[YELLOW]}$address ${COLORS[GREEN]}is ${COLORS[NC]}$balance."
done

# Change to the Tezos root directory
cd $HOME/tezos/

# Get the current cycle
cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
echo -e "\n${COLORS[BLUE]}Current cycle is ${COLORS[RED]}${cycle}${COLORS[NC]}"

# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Delegation${COLORS[NC]}"
baker_delegation_json_output=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$baker_delegation_json_output" | jq

# Get the active_staking_parameters
echo -e "\n${COLORS[RED]}Active Staking Parameters${COLORS[NC]}"
active_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/active_staking_parameters)
echo $active_staking_parameters | jq

# Get the pending staking parameters
echo -e "\n${COLORS[YELLOW]}Pending Staking Parameters${COLORS[NC]}"
pending_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/pending_staking_parameters)
echo $pending_staking_parameters | jq

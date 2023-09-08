#!/bin/bash
# ----------------------------------------------------------
# adaptive_issuance.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh
source ./time-to-next-cycle.sh

cd $HOME/tezos/

# Print the balances of the staker addresses
for address in "${staker_addresses[@]}"; do
    echo -e "\n${COLORS[YELLOW]}$address${COLORS[NC]}"
    balance=$(/home/mike/tezos/octez-client get balance for "$address")
    echo -e "${COLORS[GREEN]}Liquid balance: ${COLORS[NC]}$balance."
    staked_balance=$(/home/mike/tezos/octez-client get staked balance for "$address")
    echo -e "${COLORS[GREEN]}Staked balance: ${COLORS[NC]}$staked_balance."
    full_balance=$(/home/mike/tezos/octez-client get full balance for "$address")
    echo -e "${COLORS[GREEN]}Full balance :  ${COLORS[NC]}$full_balance."
done

# Print the balance of the baker address
baker_balance=$(/home/mike/tezos/octez-client get balance for "$baker_address")
echo -e "\n${COLORS[PURPLE]}Baker: ${COLORS[YELLOW]}$baker_address${COLORS[NC]}"
baker_balance=$(/home/mike/tezos/octez-client get balance for "$baker_address")
echo -e "${COLORS[GREEN]}Liquid balance: ${COLORS[NC]}$baker_balance."
baker_staked_balance=$(/home/mike/tezos/octez-client get staked balance for "$baker_address")
echo -e "${COLORS[GREEN]}Staked balance: ${COLORS[NC]}$baker_staked_balance."
baker_full_balance=$(/home/mike/tezos/octez-client get full balance for "$baker_address")
echo -e "${COLORS[GREEN]}Full balance :  ${COLORS[NC]}$baker_full_balance."

# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Data${COLORS[NC]}"
baker_delegation_json_output=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$baker_delegation_json_output" | jq

# Get the active_staking_parameters
echo -e "\n${COLORS[PURPLE]}Active Staking Parameters${COLORS[NC]}"
active_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/active_staking_parameters)
echo $active_staking_parameters | jq

# Get the pending staking parameters
# echo -e "\n${COLORS[YELLOW]}Pending Staking Parameters${COLORS[NC]}"
# pending_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/pending_staking_parameters)
# echo $pending_staking_parameters | jq

# Fetch the baking rights for the current cycle for the specified Tezos address.
# echo -e "\n${COLORS[PURPLE]}Baking Rights${COLORS[NC]}"
# baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${cycle}\&delegate=${baker_address}\&max_round=0  | jq 'map({level: .level})')
# echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: ${COLORS[NC]}${baking_rights}"

# Calculate the next cycle
# next_cycle=$((cycle+1))

# Ensure that the next cycle is a natural number before making the rpc call.
# if [[ "$next_cycle" =~ ^[0-9]+$ ]]
# then
# Fetch the baking rights for the next cycle for the baker Tezos address.
# next_baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${next_cycle}\&delegate=${baker_address}\&max_round=0 | jq 'map({level: .level})')
# echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${next_cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: \n${COLORS[NC]}${next_baking_rights}"
# fi

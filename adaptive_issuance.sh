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
for address in "${staker_addresses[@]}"; do
    balance=$(/home/mike/tezos/octez-client get balance for "$address")
    echo -e "${COLORS[GREEN]}The balance of ${COLORS[YELLOW]}$address ${COLORS[GREEN]}is ${COLORS[NC]}$balance."
done
# Print the balance of the baker address
baker_balance=$(/home/mike/tezos/octez-client get balance for "$baker_address")
echo -e "${COLORS[GREEN]}The balance of the baker ${COLORS[YELLOW]}$baker_address ${COLORS[GREEN]}is ${COLORS[NC]}$baker_balance."

# Change to the Tezos root directory
cd $HOME/tezos/
echo -e "\n"

# Print the staked balances of the staker addresses
for address in "${staker_addresses[@]}"; do
    staked_balance=$(./octez-admin-client rpc get /chains/main/blocks/head/context/contracts/${address}/staked_balance)
    echo -e "${COLORS[GREEN]}The staked balance of ${COLORS[YELLOW]}$address ${COLORS[GREEN]}is ${COLORS[NC]}$staked_balance."
done

# Print the staked balances of the baker address
baker_staked_balance=$(./octez-admin-client rpc get /chains/main/blocks/head/context/contracts/${baker_address}/staked_balance)
echo -e "${COLORS[GREEN]}The staked balance of the baker ${COLORS[YELLOW]}$baker_address ${COLORS[GREEN]}is ${COLORS[NC]}$baker_staked_balance."

# Get the .metadata.level_info data
cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
level=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/header | jq '.level')
echo -e "\n${COLORS[BLUE]}Cycle:${COLORS[RED]}${cycle}${COLORS[BLUE]} Level:${COLORS[RED]}${level}${COLORS[NC]}"
cycle_position=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle_position)
levels_to_next_cycle=$((8192 - ${cycle_position}))
seconds_to_next_cycle=$((levels_to_next_cycle * 8))
minutes_to_next_cycle=$((seconds_to_next_cycle / 60))
echo -e "${COLORS[BLUE]}Levels to next cycle: ${COLORS[PURPLE]}${levels_to_next_cycle}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Minutes to next cycle: ${COLORS[PURPLE]}${minutes_to_next_cycle}${COLORS[NC]}"

# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Data${COLORS[NC]}"
baker_delegation_json_output=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$baker_delegation_json_output" | jq

# Get the active_staking_parameters
echo -e "\n${COLORS[PURPLE]}Active Staking Parameters${COLORS[NC]}"
active_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/active_staking_parameters)
echo $active_staking_parameters | jq

# Get the pending staking parameters
echo -e "\n${COLORS[YELLOW]}Pending Staking Parameters${COLORS[NC]}"
pending_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/pending_staking_parameters)
echo $pending_staking_parameters | jq

# Fetch the baking rights for the current cycle for the specified Tezos address.
echo -e "\n${COLORS[PURPLE]}Baking Rights${COLORS[NC]}"
baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${cycle}\&delegate=${baker_address}\&max_round=0  | jq 'map({level: .level, estimated_time: .estimated_time})')
echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: ${COLORS[NC]}${baking_rights}"

# Calculate the next cycle
next_cycle=$((cycle+1))

# Ensure that the next cycle is a natural number before making the rpc call.
if [[ "$next_cycle" =~ ^[0-9]+$ ]]
then
    # Fetch the baking rights for the next cycle for the baker Tezos address.
    next_baking_rights=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${next_cycle}\&delegate=${baker_address}\&max_round=0 | jq 'map({level: .level, estimated_time: .estimated_time})')
    echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${next_cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: \n${COLORS[NC]}${next_baking_rights}"
fi

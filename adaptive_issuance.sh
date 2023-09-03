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

# Disable the Tezos client disclaimer
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=y

# Define colors for output formatting
declare -A COLORS=(
     [RED]='\033[0;31m'
     [GREEN]='\033[0;32m'
     [BLUE]='\033[1;34m'
     [YELLOW]='\033[1;33m'
     [NC]='\033[0m' 
 )

# List of staker addresses
staker_addresses=(
"tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y"
"tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42"
"tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD"
)

# Baker address
baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

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

# Get the pending staking parameters
echo -e "${COLORS[BLUE]}Pending Staking Parameters${COLORS[NC]}"
pending_staking_parameters=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/pending_staking_parameters)
echo $pending_staking_parameters | jq
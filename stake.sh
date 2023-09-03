#!/bin/bash
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=y
declare -A COLORS=(
     [RED]='\033[0;31m'
     [GREEN]='\033[0;32m'
     [BLUE]='\033[1;34m'
     [YELLOW]='\033[1;33m'
     [LIGHT_RED]='\033[1;31m'
     [NC]='\033[0m' # No Color
 )
staker_addresses=(
"tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y"
"tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42"
"tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD"
)

# Prompt the user for the amount to transfer
read -p "Enter the amount to stake: " amount

# Iterate over the list of addresses
for address in "${staker_addresses[@]}"; do
    # Use the octez-client command to transfer tez from the address to the target address
    /home/mike/tezos/octez-client transfer $amount from $address to $address --entrypoint stake

    # Print a message indicating that the transfer has been initiated
    echo -e "${COLORS[GREEN]}Initiated a staking transfer of ${COLORS[NC]}$amount ${COLORS[GREEN]}from ${COLORS[YELLOW]}$address ${COLORS[GREEN]}to ${COLORS[YELLOW]}$address.${COLORS[NC]}"
done


 

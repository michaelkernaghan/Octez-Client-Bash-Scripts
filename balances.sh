#!/bin/bash
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=y
# Define some colors using associative array
declare -A COLORS=(
     [RED]='\033[0;31m'
     [GREEN]='\033[0;32m'
     [BLUE]='\033[1;34m'
     [YELLOW]='\033[1;33m'
     [LIGHT_RED]='\033[1;31m'
     [NC]='\033[0m' # No Color
 )
# List of octez addresses
addresses=(
"tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y"
"tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42"
"tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD"
"tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"
)

# Iterate over the list of addresses
for address in "${addresses[@]}"; do
    # Use the octez-client command to check the balance of the address
    balance=$(/home/mike/tezos/octez-client get balance for "$address")
    # Print the balance
    echo -e "${COLORS[GREEN]}The balance of ${COLORS[YELLOW]}$address ${COLORS[GREEN]}is ${COLORS[NC]}$balance.}"
done

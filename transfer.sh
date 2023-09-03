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
# List of octez addresses
staker_addresses=(
"tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y"
"tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42"
"tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD"
)

# Target octez address
baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

# Prompt the user for the amount to transfer
read -p "Enter the amount to transfer: " amount

# Iterate over the list of addresses
for address in "${staker_addresses[@]}"; do
    # Use the octez-client command to transfer tez from the address to the target address
    /home/mike/tezos/octez-client transfer $amount from $address to $baker_address >/dev/null

    # Print a message indicating that the transfer has been initiated
    echo -e "${COLORS[GREEN]}Initiated a transfer of ${COLORS[NC]}$amount ${COLORS[GREEN]}from ${COLORS[YELLOW]}$address ${COLORS[GREEN]}to ${COLORS[YELLOW]}$baker_address.${COLORS[NC]}"
done

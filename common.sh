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

#!/bin/bash
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=y
declare -A COLORS=(
     [RED]='\033[0;31m'
     [GREEN]='\033[0;32m'
     [BLUE]='\033[1;34m'
     [YELLOW]='\033[1;33m'
     [PURPLE]='\033[0;35m'
     [NC]='\033[0m' # No Color
 )
# List of octez addresses
staker_addresses=(
"tz1XDL5EuVrKXxa6bawcA7oRfLBgvH2uWtWi"
"tz1iwkGcTgtvLNe2p1hgZDjT44AEnqVECx9h"
"tz1QZZHTf8icGPUwiTCNd6n7zeAK8ZoU4QQo"
)

# Target octez address
baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

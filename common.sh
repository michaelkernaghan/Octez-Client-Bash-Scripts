#!/bin/bash
# Common configuration for Octez client scripts (Seoul protocol compatible)
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=y

# Color definitions for better script output
declare -A COLORS=(
     [RED]='\033[0;31m'
     [GREEN]='\033[0;32m'
     [BLUE]='\033[1;34m'
     [YELLOW]='\033[1;33m'
     [PURPLE]='\033[0;35m'
     [NC]='\033[0m' # No Color
 )

# Protocol constants for Seoul (updated from Oxford)
# Block time: 10 seconds (changed from 15s in Oxford)
# Blocks per cycle: 24576 (changed from 8192 in Oxford)
BLOCK_TIME_SECONDS=10
BLOCKS_PER_CYCLE=24576

# List of staker addresses (Update these with your actual addresses)
staker_addresses=(
"tz1XDL5EuVrKXxa6bawcA7oRfLBgvH2uWtWi"
"tz1iwkGcTgtvLNe2p1hgZDjT44AEnqVECx9h"
"tz1QZZHTf8icGPUwiTCNd6n7zeAK8ZoU4QQo"
)

# Baker address (Update this with your actual baker address)
baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

# Function to check if octez-client is available
check_octez_client() {
    if ! command -v octez-client &> /dev/null; then
        echo -e "${COLORS[RED]}Error: octez-client not found in PATH${COLORS[NC]}"
        echo -e "${COLORS[YELLOW]}Please ensure Octez is installed and octez-client is in your PATH${COLORS[NC]}"
        exit 1
    fi
}

# Function to check if octez-admin-client is available
check_octez_admin_client() {
    if ! command -v octez-admin-client &> /dev/null; then
        echo -e "${COLORS[RED]}Error: octez-admin-client not found in PATH${COLORS[NC]}"
        echo -e "${COLORS[YELLOW]}Please ensure Octez is installed and octez-admin-client is in your PATH${COLORS[NC]}"
        exit 1
    fi
}

# Function to get current cycle information
get_current_cycle_info() {
    local current_level=$(octez-client rpc get /chains/main/blocks/head/helpers/current_level 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$current_level"
    else
        echo -e "${COLORS[RED]}Error: Could not fetch current level information${COLORS[NC]}"
        return 1
    fi
}

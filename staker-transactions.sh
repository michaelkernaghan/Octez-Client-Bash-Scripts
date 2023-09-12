#!/bin/bash
# staker-transactions.sh
# Michael Kernaghan
#--------------------------------------------------------------
# You can run the transfer script to create operations for this script to find.
# The script is set for looking back 50 blocks. 8 second blocks means 400 seconds, or 6.5 minutes of history.
# This script fetches and prints the transaction history for a specific Tezos address by checking the last 100 blocks.
# The `-n` test checks if the `transactions` variable is non-empty, which would indicate that transactions were found.
# If transactions were found, the script prints the level and the transactions
# The `transaction_levels+=($level)` line adds the current level to the `transaction_levels` list each time transactions are found.
# After the loop is done, the script prints the list of levels where transactions were found.
# The `transaction_metadata[$level]=$transactions` line adds the transaction metadata to the `transaction_metadata` associative array keyed by the level.
# After the loop is done, the script loops over the `transaction_levels` list and prints the transaction metadata for each level.
#--------------------------------------------------------------

# Import common shell script functions and variables
source ./common.sh

# Define the Tezos address that we are interested in. This is the address whose transaction history we want to check.
staker_address="tz1XDL5EuVrKXxa6bawcA7oRfLBgvH2uWtWi"

# Fetch the current head block level. The head block is the most recent block in the Tezos blockchain.
head_level=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/header | jq '.level')

# Calculate the start level. We are interested in the last 250 blocks, so we subtract 50 from the head level.
start_level=$((head_level - 250))

# Initialize a counter for the number of blocks where transactions were found
transaction_blocks=0

# Initialize a list to store the levels where transactions were found
transaction_levels=()

# Initialize an associative array to store the transaction metadata keyed by the level
declare -A transaction_metadata

# Start a loop that will iterate from the head level to the start level.
for ((level = head_level; level >= start_level; level--)); do

    # Display the level being checked
    echo -e "${COLORS[BLUE]}Level: $level${COLORS[NC]}"

    # Get the block hash for the current level. The block hash is a unique identifier for each block.
    block_hash=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/$level/hash | tr -d '"')

    # Fetch all operations in the current block. Operations include transactions, but also other types of actions on the Tezos network.
    operations=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/$block_hash/operations)

    # Parse the operations to filter out transactions related to our address of interest. We use the 'grep' command to search for our address in the operations data.
    transactions=$(echo "$operations" | grep -A18 "$staker_address" --no-group-separator)

    # If transactions were found, print the level and the transactions, increment the counter, and add the level and metadata to the list and array
    if [[ -n $transactions ]]; then
        echo -e "${COLORS[BLUE]}Transactions found at level: ${COLORS[RED]}$level${COLORS[NC]}"
        #echo "$transactions"
        ((transaction_blocks++))
        transaction_levels+=($level)
        transaction_metadata[$level]=$transactions
    fi
done

# Print the summary
echo -e "${COLORS[GREEN]}Summary: Transactions were found in $transaction_blocks out of 250 checked blocks.${COLORS[NC]}"
echo -e "${COLORS[GREEN]}The transactions were found at the following levels: ${transaction_levels[@]}${COLORS[NC]}"

# Print the transaction metadata for each level
for level in "${transaction_levels[@]}"; do
    echo -e "${COLORS[GREEN]}Transaction at level ${COLORS[RED]}$level:${COLORS[NC]}"
    echo "${transaction_metadata[$level]}"
done

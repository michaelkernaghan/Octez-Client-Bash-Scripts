#!/bin/bash
# ----------------------------------------------------------
# native-multisig.sh
# Michael Kernaghan  
# Utilities for working with native multisig accounts (Seoul protocol feature)
#-----------------------------------------------------------

source ./common.sh

# Function to create a native multisig account
create_native_multisig() {
    echo -e "\n${COLORS[BLUE]}=== Creating Native Multisig Account ===${COLORS[NC]}"
    
    read -p "Enter the threshold (minimum number of signatures required): " threshold
    read -p "Enter the number of public keys: " num_keys
    
    if [ -z "$threshold" ] || [ -z "$num_keys" ]; then
        echo -e "${COLORS[RED]}Error: Threshold and number of keys are required${COLORS[NC]}"
        return 1
    fi
    
    # Collect public keys
    public_keys=()
    for ((i=1; i<=num_keys; i++)); do
        read -p "Enter public key $i: " pubkey
        if [ -n "$pubkey" ]; then
            public_keys+=("$pubkey")
        else
            echo -e "${COLORS[RED]}Error: Public key $i cannot be empty${COLORS[NC]}"
            return 1
        fi
    done
    
    echo -e "\n${COLORS[GREEN]}Creating native multisig account...${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}Threshold: ${COLORS[YELLOW]}$threshold${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}Public keys:${COLORS[NC]}"
    for key in "${public_keys[@]}"; do
        echo -e "  ${COLORS[YELLOW]}$key${COLORS[NC]}"
    done
    
    # Build the command
    cmd="octez-client originate multisig contract --threshold $threshold"
    for key in "${public_keys[@]}"; do
        cmd="$cmd --public-key $key"
    done
    
    echo -e "\n${COLORS[PURPLE]}Command to execute:${COLORS[NC]}"
    echo "$cmd"
    
    read -p "Do you want to execute this command? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        eval $cmd
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to check multisig account info
check_multisig_info() {
    echo -e "\n${COLORS[BLUE]}=== Multisig Account Information ===${COLORS[NC]}"
    
    read -p "Enter the multisig account address: " multisig_address
    
    if [ -z "$multisig_address" ]; then
        echo -e "${COLORS[RED]}Error: Multisig address is required${COLORS[NC]}"
        return 1
    fi
    
    echo -e "\n${COLORS[GREEN]}Fetching multisig account information...${COLORS[NC]}"
    
    # Get general account info
    echo -e "\n${COLORS[PURPLE]}Account Info:${COLORS[NC]}"
    octez-client rpc get /chains/main/blocks/head/context/contracts/$multisig_address
    
    # Get balance
    echo -e "\n${COLORS[PURPLE]}Balance:${COLORS[NC]}"
    balance=$(octez-client get balance for $multisig_address)
    echo -e "${COLORS[BLUE]}Balance: ${COLORS[YELLOW]}$balance${COLORS[NC]}"
    
    # Check if it's a multisig account and get details
    echo -e "\n${COLORS[PURPLE]}Multisig Details:${COLORS[NC]}"
    multisig_info=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$multisig_address/storage 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$multisig_info" | jq
    else
        echo -e "${COLORS[YELLOW]}Could not retrieve multisig details (may not be a multisig account)${COLORS[NC]}"
    fi
}

# Function to prepare a multisig transaction
prepare_multisig_transaction() {
    echo -e "\n${COLORS[BLUE]}=== Prepare Multisig Transaction ===${COLORS[NC]}"
    
    read -p "Enter the multisig account address: " multisig_address
    read -p "Enter the destination address: " destination
    read -p "Enter the amount to transfer: " amount
    read -p "Enter the sequence number (or press Enter for auto): " sequence
    
    if [ -z "$multisig_address" ] || [ -z "$destination" ] || [ -z "$amount" ]; then
        echo -e "${COLORS[RED]}Error: Multisig address, destination, and amount are required${COLORS[NC]}"
        return 1
    fi
    
    echo -e "\n${COLORS[GREEN]}Preparing multisig transaction...${COLORS[NC]}"
    
    # Build the command
    cmd="octez-client prepare multisig transaction on $multisig_address transferring $amount to $destination"
    
    if [ -n "$sequence" ]; then
        cmd="$cmd --sequence-number $sequence"
    fi
    
    echo -e "\n${COLORS[PURPLE]}Command to execute:${COLORS[NC]}"
    echo "$cmd"
    
    read -p "Do you want to execute this command? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        eval $cmd
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to sign a multisig transaction
sign_multisig_transaction() {
    echo -e "\n${COLORS[BLUE]}=== Sign Multisig Transaction ===${COLORS[NC]}"
    
    read -p "Enter the multisig account address: " multisig_address
    read -p "Enter the transaction hash to sign: " tx_hash
    read -p "Enter the signing key alias: " signing_key
    
    if [ -z "$multisig_address" ] || [ -z "$tx_hash" ] || [ -z "$signing_key" ]; then
        echo -e "${COLORS[RED]}Error: All fields are required${COLORS[NC]}"
        return 1
    fi
    
    echo -e "\n${COLORS[GREEN]}Signing multisig transaction...${COLORS[NC]}"
    
    cmd="octez-client sign multisig transaction $tx_hash for $multisig_address with $signing_key"
    
    echo -e "\n${COLORS[PURPLE]}Command to execute:${COLORS[NC]}"
    echo "$cmd"
    
    read -p "Do you want to execute this command? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        eval $cmd
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to execute a multisig transaction
execute_multisig_transaction() {
    echo -e "\n${COLORS[BLUE]}=== Execute Multisig Transaction ===${COLORS[NC]}"
    
    read -p "Enter the multisig account address: " multisig_address
    read -p "Enter the transaction hash to execute: " tx_hash
    
    if [ -z "$multisig_address" ] || [ -z "$tx_hash" ]; then
        echo -e "${COLORS[RED]}Error: Multisig address and transaction hash are required${COLORS[NC]}"
        return 1
    fi
    
    echo -e "\n${COLORS[GREEN]}Executing multisig transaction...${COLORS[NC]}"
    
    cmd="octez-client execute multisig transaction $tx_hash on $multisig_address"
    
    echo -e "\n${COLORS[PURPLE]}Command to execute:${COLORS[NC]}"
    echo "$cmd"
    
    read -p "Do you want to execute this command? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        eval $cmd
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to list pending multisig transactions
list_pending_transactions() {
    echo -e "\n${COLORS[BLUE]}=== List Pending Multisig Transactions ===${COLORS[NC]}"
    
    read -p "Enter the multisig account address: " multisig_address
    
    if [ -z "$multisig_address" ]; then
        echo -e "${COLORS[RED]}Error: Multisig address is required${COLORS[NC]}"
        return 1
    fi
    
    echo -e "\n${COLORS[GREEN]}Fetching pending transactions...${COLORS[NC]}"
    
    cmd="octez-client show multisig transactions for $multisig_address"
    
    echo -e "\n${COLORS[PURPLE]}Command to execute:${COLORS[NC]}"
    echo "$cmd"
    
    eval $cmd
}

# Main menu
show_menu() {
    echo -e "\n${COLORS[PURPLE]}=== Native Multisig Menu ===${COLORS[NC]}"
    echo ""
    echo "1) Create native multisig account"
    echo "2) Check multisig account info"
    echo "3) Prepare multisig transaction"
    echo "4) Sign multisig transaction"
    echo "5) Execute multisig transaction"
    echo "6) List pending transactions"
    echo "7) Help - Show example workflow"
    echo "0) Exit"
    echo ""
}

# Help function
show_help() {
    echo -e "\n${COLORS[BLUE]}=== Native Multisig Workflow Example ===${COLORS[NC]}"
    echo ""
    echo -e "${COLORS[GREEN]}1. Create a multisig account:${COLORS[NC]}"
    echo "   - Choose threshold (e.g., 2 out of 3)"
    echo "   - Provide public keys of all signers"
    echo ""
    echo -e "${COLORS[GREEN]}2. Fund the multisig account:${COLORS[NC]}"
    echo "   - Transfer tez to the multisig address"
    echo ""
    echo -e "${COLORS[GREEN]}3. Create a transaction:${COLORS[NC]}"
    echo "   - Use 'prepare multisig transaction' option"
    echo "   - This creates a transaction proposal"
    echo ""
    echo -e "${COLORS[GREEN]}4. Collect signatures:${COLORS[NC]}"
    echo "   - Each required signer uses 'sign multisig transaction'"
    echo "   - Need to reach the threshold number of signatures"
    echo ""
    echo -e "${COLORS[GREEN]}5. Execute the transaction:${COLORS[NC]}"
    echo "   - Once threshold is reached, execute the transaction"
    echo ""
    echo -e "${COLORS[YELLOW]}Note: Native multisig accounts are a Seoul protocol feature${COLORS[NC]}"
}

# Main script
echo -e "${COLORS[PURPLE]}Octez Native Multisig Utilities${COLORS[NC]}"
echo -e "${COLORS[YELLOW]}Seoul Protocol Feature${COLORS[NC]}"

while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1) create_native_multisig ;;
        2) check_multisig_info ;;
        3) prepare_multisig_transaction ;;
        4) sign_multisig_transaction ;;
        5) execute_multisig_transaction ;;
        6) list_pending_transactions ;;
        7) show_help ;;
        0) echo -e "${COLORS[GREEN]}Exiting...${COLORS[NC]}"; break ;;
        *) echo -e "${COLORS[RED]}Invalid option${COLORS[NC]}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
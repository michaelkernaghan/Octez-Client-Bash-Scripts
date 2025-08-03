#!/bin/bash
# ----------------------------------------------------------
# unstake-workflow.sh
# Michael Kernaghan  
# Comprehensive workflow for unstaking funds from a baker
#-----------------------------------------------------------

source ./common.sh

# Configuration
BAKER_ADDRESS="${1:-$baker_address}"  # Use parameter or default from common.sh

if [ -z "$BAKER_ADDRESS" ]; then
    echo -e "${COLORS[RED]}Error: Baker address not provided. Usage: $0 <baker_address>${COLORS[NC]}"
    exit 1
fi

# Function to check current cycle and level
check_current_state() {
    echo -e "\n${COLORS[BLUE]}=== Current Network State ===${COLORS[NC]}"
    current_level=$(octez-client rpc get /chains/main/blocks/head/helpers/current_level)
    echo -e "${COLORS[GREEN]}Current level info:${COLORS[NC]}"
    echo "$current_level" | jq
    
    cycle=$(echo "$current_level" | jq -r '.cycle')
    echo -e "${COLORS[BLUE]}Current cycle: ${COLORS[YELLOW]}$cycle${COLORS[NC]}"
}

# Function to check baker status
check_baker_status() {
    echo -e "\n${COLORS[BLUE]}=== Baker Status ===${COLORS[NC]}"
    
    # Get baker info
    baker_info=$(octez-client rpc get /chains/main/blocks/head/context/delegates/$BAKER_ADDRESS)
    echo -e "${COLORS[GREEN]}Baker information:${COLORS[NC]}"
    echo "$baker_info" | jq
    
    # Check spendable balance
    spendable_balance=$(octez-client get balance for $BAKER_ADDRESS)
    echo -e "${COLORS[BLUE]}Spendable balance: ${COLORS[YELLOW]}$spendable_balance${COLORS[NC]}"
    
    # Check staked balance
    staked_balance=$(octez-client get staked balance for $BAKER_ADDRESS)
    echo -e "${COLORS[BLUE]}Staked balance: ${COLORS[YELLOW]}$staked_balance${COLORS[NC]}"
    
    # Check full balance
    full_balance=$(octez-client get full balance for $BAKER_ADDRESS)
    echo -e "${COLORS[BLUE]}Full balance: ${COLORS[YELLOW]}$full_balance${COLORS[NC]}"
    
    # Check unstaked balances
    unstaked_finalizable=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$BAKER_ADDRESS/unstaked_finalizable_balance)
    echo -e "${COLORS[BLUE]}Unstaked finalizable balance: ${COLORS[PURPLE]}$unstaked_finalizable${COLORS[NC]}"
    
    unstaked_frozen=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$BAKER_ADDRESS/unstaked_frozen_balance)
    echo -e "${COLORS[BLUE]}Unstaked frozen balance: ${COLORS[PURPLE]}$unstaked_frozen${COLORS[NC]}"
}

# Function to check staking parameters
check_staking_parameters() {
    echo -e "\n${COLORS[BLUE]}=== Staking Parameters ===${COLORS[NC]}"
    
    # Check active staking parameters
    active_params=$(octez-client rpc get /chains/main/blocks/head/context/delegates/$BAKER_ADDRESS/active_staking_parameters)
    echo -e "${COLORS[GREEN]}Active staking parameters:${COLORS[NC]}"
    echo "$active_params" | jq
    
    # Check pending staking parameters
    pending_params=$(octez-client rpc get /chains/main/blocks/head/context/delegates/$BAKER_ADDRESS/pending_staking_parameters)
    echo -e "${COLORS[GREEN]}Pending staking parameters:${COLORS[NC]}"
    echo "$pending_params" | jq
}

# Function to check delegators
check_delegators() {
    echo -e "\n${COLORS[BLUE]}=== Current Delegators ===${COLORS[NC]}"
    
    delegators=$(octez-client rpc get /chains/main/blocks/head/context/delegates/$BAKER_ADDRESS/delegators)
    echo -e "${COLORS[GREEN]}Current delegators:${COLORS[NC]}"
    echo "$delegators" | jq
}

# Function to set staking limit to 0
set_staking_limit_zero() {
    echo -e "\n${COLORS[BLUE]}=== Setting Staking Limit to 0 ===${COLORS[NC]}"
    echo -e "${COLORS[YELLOW]}Warning: This will prevent new delegations and take effect after consensus_rights_delay cycles${COLORS[NC]}"
    
    read -p "Do you want to set the staking limit to 0? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        echo -e "${COLORS[GREEN]}Setting staking parameters...${COLORS[NC]}"
        octez-client set delegate parameters for $BAKER_ADDRESS --limit-of-staking-over-baking 0 --edge-of-baking-over-staking 1
        echo -e "${COLORS[GREEN]}Staking limit set to 0${COLORS[NC]}"
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to unstake everything
unstake_everything() {
    echo -e "\n${COLORS[BLUE]}=== Unstaking All Funds ===${COLORS[NC]}"
    echo -e "${COLORS[YELLOW]}Warning: This will unstake all staked funds${COLORS[NC]}"
    
    read -p "Do you want to unstake all funds? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        echo -e "${COLORS[GREEN]}Unstaking all funds...${COLORS[NC]}"
        octez-client unstake everything for $BAKER_ADDRESS
        echo -e "${COLORS[GREEN]}Unstaking initiated${COLORS[NC]}"
    else
        echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
    fi
}

# Function to finalize unstake
finalize_unstake() {
    echo -e "\n${COLORS[BLUE]}=== Finalizing Unstake ===${COLORS[NC]}"
    
    # Check if there are finalizable funds
    finalizable=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$BAKER_ADDRESS/unstaked_finalizable_balance)
    finalizable_amount=$(echo "$finalizable" | jq -r '. // "0"')
    
    if [ "$finalizable_amount" != "0" ] && [ "$finalizable_amount" != "null" ]; then
        echo -e "${COLORS[GREEN]}Finalizable amount: ${COLORS[YELLOW]}$finalizable_amount mutez${COLORS[NC]}"
        
        read -p "Do you want to finalize the unstake? (y/N): " confirm
        if [[ $confirm == [yY] ]]; then
            echo -e "${COLORS[GREEN]}Finalizing unstake...${COLORS[NC]}"
            octez-client finalize unstake for $BAKER_ADDRESS
            echo -e "${COLORS[GREEN]}Unstake finalized${COLORS[NC]}"
        else
            echo -e "${COLORS[RED]}Operation cancelled${COLORS[NC]}"
        fi
    else
        echo -e "${COLORS[YELLOW]}No funds available for finalization${COLORS[NC]}"
    fi
}

# Function to transfer remaining funds
transfer_funds() {
    echo -e "\n${COLORS[BLUE]}=== Transfer Remaining Funds ===${COLORS[NC]}"
    
    current_balance=$(octez-client get balance for $BAKER_ADDRESS)
    echo -e "${COLORS[GREEN]}Current spendable balance: ${COLORS[YELLOW]}$current_balance${COLORS[NC]}"
    
    read -p "Enter destination address: " destination
    read -p "Enter amount to transfer (leave some for fees): " amount
    
    if [ -n "$destination" ] && [ -n "$amount" ]; then
        echo -e "${COLORS[GREEN]}Transferring $amount to $destination...${COLORS[NC]}"
        octez-client transfer $amount from $BAKER_ADDRESS to $destination
        echo -e "${COLORS[GREEN]}Transfer completed${COLORS[NC]}"
    else
        echo -e "${COLORS[RED]}Invalid destination or amount${COLORS[NC]}"
    fi
}

# Main menu
show_menu() {
    echo -e "\n${COLORS[PURPLE]}=== Unstaking Workflow Menu ===${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}Baker Address: ${COLORS[YELLOW]}$BAKER_ADDRESS${COLORS[NC]}"
    echo ""
    echo "1) Check current state and baker status"
    echo "2) Check staking parameters"
    echo "3) Check delegators"
    echo "4) Set staking limit to 0"
    echo "5) Unstake everything"
    echo "6) Finalize unstake"
    echo "7) Transfer remaining funds"
    echo "8) Full status check"
    echo "0) Exit"
    echo ""
}

# Full status check
full_status_check() {
    check_current_state
    check_baker_status
    check_staking_parameters
    check_delegators
}

# Main script
echo -e "${COLORS[PURPLE]}Octez Unstaking Workflow${COLORS[NC]}"
echo -e "${COLORS[YELLOW]}Baker Address: $BAKER_ADDRESS${COLORS[NC]}"

while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1) check_current_state; check_baker_status ;;
        2) check_staking_parameters ;;
        3) check_delegators ;;
        4) set_staking_limit_zero ;;
        5) unstake_everything ;;
        6) finalize_unstake ;;
        7) transfer_funds ;;
        8) full_status_check ;;
        0) echo -e "${COLORS[GREEN]}Exiting...${COLORS[NC]}"; break ;;
        *) echo -e "${COLORS[RED]}Invalid option${COLORS[NC]}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
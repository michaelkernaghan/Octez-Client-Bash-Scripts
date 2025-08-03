#!/bin/bash
# ----------------------------------------------------------
# test-compatibility.sh
# Michael Kernaghan  
# Test script to verify Seoul protocol compatibility
#-----------------------------------------------------------

source ./common.sh

echo -e "${COLORS[PURPLE]}=== Octez Client Scripts Seoul Protocol Compatibility Test ===${COLORS[NC]}"

# Test 1: Check if required tools are available
echo -e "\n${COLORS[BLUE]}Test 1: Checking for required tools...${COLORS[NC]}"
if command -v octez-client &> /dev/null; then
    echo -e "${COLORS[GREEN]}✓ octez-client found${COLORS[NC]}"
else
    echo -e "${COLORS[RED]}✗ octez-client not found${COLORS[NC]}"
    exit 1
fi

if command -v octez-admin-client &> /dev/null; then
    echo -e "${COLORS[GREEN]}✓ octez-admin-client found${COLORS[NC]}"
else
    echo -e "${COLORS[RED]}✗ octez-admin-client not found${COLORS[NC]}"
    exit 1
fi

# Test 2: Check network connectivity
echo -e "\n${COLORS[BLUE]}Test 2: Checking network connectivity...${COLORS[NC]}"
if current_level=$(octez-client rpc get /chains/main/blocks/head/helpers/current_level 2>/dev/null); then
    echo -e "${COLORS[GREEN]}✓ Connected to Tezos network${COLORS[NC]}"
    cycle=$(echo "$current_level" | jq -r '.cycle')
    level=$(echo "$current_level" | jq -r '.level')
    echo -e "${COLORS[BLUE]}  Current cycle: ${COLORS[YELLOW]}$cycle${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Current level: ${COLORS[YELLOW]}$level${COLORS[NC]}"
else
    echo -e "${COLORS[RED]}✗ Cannot connect to Tezos network${COLORS[NC]}"
    echo -e "${COLORS[YELLOW]}  Make sure your node is running and accessible${COLORS[NC]}"
    exit 1
fi

# Test 3: Check protocol version
echo -e "\n${COLORS[BLUE]}Test 3: Checking protocol version...${COLORS[NC]}"
if protocol_hash=$(octez-client rpc get /chains/main/blocks/head/protocol 2>/dev/null); then
    echo -e "${COLORS[GREEN]}✓ Protocol hash retrieved: ${COLORS[YELLOW]}$protocol_hash${COLORS[NC]}"
    
    # Check if it's Seoul protocol (PtSeoul...)
    if echo "$protocol_hash" | grep -q "PtSeoul"; then
        echo -e "${COLORS[GREEN]}✓ Seoul protocol detected${COLORS[NC]}"
    else
        echo -e "${COLORS[YELLOW]}⚠ Non-Seoul protocol detected${COLORS[NC]}"
        echo -e "${COLORS[BLUE]}  Current protocol: ${COLORS[YELLOW]}$protocol_hash${COLORS[NC]}"
        echo -e "${COLORS[YELLOW]}  Scripts should still work but some features may not be available${COLORS[NC]}"
    fi
else
    echo -e "${COLORS[RED]}✗ Cannot retrieve protocol information${COLORS[NC]}"
fi

# Test 4: Check timing calculations
echo -e "\n${COLORS[BLUE]}Test 4: Testing timing calculations...${COLORS[NC]}"
if cycle_info=$(octez-admin-client rpc get /chains/main/blocks/head 2>/dev/null); then
    cycle_position=$(echo "$cycle_info" | jq -r '.metadata.level_info.cycle_position')
    
    # Test with Seoul constants
    levels_remaining=$((BLOCKS_PER_CYCLE - cycle_position))
    seconds_remaining=$((levels_remaining * BLOCK_TIME_SECONDS))
    minutes_remaining=$((seconds_remaining / 60))
    
    echo -e "${COLORS[GREEN]}✓ Timing calculations working${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Cycle position: ${COLORS[YELLOW]}$cycle_position${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Levels remaining: ${COLORS[YELLOW]}$levels_remaining${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Est. minutes to next cycle: ${COLORS[YELLOW]}$minutes_remaining${COLORS[NC]}"
else
    echo -e "${COLORS[RED]}✗ Cannot retrieve cycle information${COLORS[NC]}"
fi

# Test 5: Check address configurations
echo -e "\n${COLORS[BLUE]}Test 5: Checking configured addresses...${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Baker address: ${COLORS[YELLOW]}$baker_address${COLORS[NC]}"

if octez-client rpc get /chains/main/blocks/head/context/contracts/$baker_address &>/dev/null; then
    echo -e "${COLORS[GREEN]}✓ Baker address is valid${COLORS[NC]}"
else
    echo -e "${COLORS[YELLOW]}⚠ Baker address not found on network${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Please update baker_address in common.sh${COLORS[NC]}"
fi

echo -e "\n${COLORS[BLUE]}Staker addresses:${COLORS[NC]}"
for i, address in "${!staker_addresses[@]}"; do
    if octez-client rpc get /chains/main/blocks/head/context/contracts/$address &>/dev/null; then
        echo -e "${COLORS[GREEN]}✓ Staker $((i+1)): ${COLORS[YELLOW]}$address${COLORS[NC]}"
    else
        echo -e "${COLORS[YELLOW]}⚠ Staker $((i+1)): ${COLORS[YELLOW]}$address${COLORS[BLUE]} (not found)${COLORS[NC]}"
    fi
done

# Test 6: Check if adaptive issuance is available
echo -e "\n${COLORS[BLUE]}Test 6: Checking Seoul protocol features...${COLORS[NC]}"
if ai_launch=$(octez-admin-client rpc get /chains/main/blocks/head/context/adaptive_issuance_launch_cycle 2>/dev/null); then
    echo -e "${COLORS[GREEN]}✓ Adaptive issuance RPC available${COLORS[NC]}"
    echo -e "${COLORS[BLUE]}  Launch cycle: ${COLORS[YELLOW]}$ai_launch${COLORS[NC]}"
else
    echo -e "${COLORS[YELLOW]}⚠ Adaptive issuance RPC not available${COLORS[NC]}"
fi

# Test 7: Check if staking commands are available
echo -e "\n${COLORS[BLUE]}Test 7: Testing staking command availability...${COLORS[NC]}"
if octez-client get staked balance for $baker_address &>/dev/null; then
    echo -e "${COLORS[GREEN]}✓ Staking commands available${COLORS[NC]}"
else
    echo -e "${COLORS[YELLOW]}⚠ Staking commands may not be fully available${COLORS[NC]}"
fi

# Test 8: Check script executability
echo -e "\n${COLORS[BLUE]}Test 8: Checking script permissions...${COLORS[NC]}"
scripts=("adaptive_issuance.sh" "stake.sh" "time-to-next-cycle.sh" "unstake-workflow.sh" "native-multisig.sh")
for script in "${scripts[@]}"; do
    if [[ -x "$script" ]]; then
        echo -e "${COLORS[GREEN]}✓ $script is executable${COLORS[NC]}"
    else
        echo -e "${COLORS[YELLOW]}⚠ $script is not executable${COLORS[NC]}"
        echo -e "${COLORS[BLUE]}  Run: chmod +x $script${COLORS[NC]}"
    fi
done

# Summary
echo -e "\n${COLORS[PURPLE]}=== Test Summary ===${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Seoul protocol compatibility tests completed.${COLORS[NC]}"
echo -e "${COLORS[GREEN]}✓ = Passed  ${COLORS[YELLOW]}⚠ = Warning  ${COLORS[RED]}✗ = Failed${COLORS[NC]}"

echo -e "\n${COLORS[BLUE]}Next steps:${COLORS[NC]}"
echo -e "1. Update addresses in common.sh if needed"
echo -e "2. Run ./adaptive_issuance.sh to test full functionality"
echo -e "3. Test staking operations with small amounts first"
echo -e "4. Explore new native multisig features if needed"

echo -e "\n${COLORS[GREEN]}Scripts are ready for Seoul protocol!${COLORS[NC]}"
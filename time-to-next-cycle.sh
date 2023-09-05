#!/bin/bash
# ----------------------------------------------------------
# time-to-next-cycle.sh
# Michael Kernaghan
#-----------------------------------------------------------
# ----------------------------------------------------------

source ./common.sh

# Change to the Tezos root directory
cd $HOME/tezos/


cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
level=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/header | jq '.level')
echo -e "\n${COLORS[BLUE]}Cycle:${COLORS[RED]}${cycle}${COLORS[BLUE]} Level:${COLORS[RED]}${level}${COLORS[NC]}"
cycle_position=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle_position)
levels_to_next_cycle=$((8192 - ${cycle_position}))
seconds_to_next_cycle=$((levels_to_next_cycle * 8))
minutes_to_next_cycle=$((seconds_to_next_cycle / 60))
echo -e "${COLORS[BLUE]}Levels to next cycle: ${COLORS[YELLOW]}${levels_to_next_cycle}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Minutes to next cycle: ${COLORS[YELLOW]}${minutes_to_next_cycle}${COLORS[NC]}"

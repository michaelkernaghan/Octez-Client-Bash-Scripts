#!/bin/bash
# ----------------------------------------------------------
# time-to-next-cycle.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh
cd $HOME/tezos/

cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
level=$(/home/mike/tezos/octez-client rpc get /chains/main/blocks/head/header | jq '.level')
echo -e "\n${COLORS[BLUE]}Cycle:${COLORS[RED]}${cycle}${COLORS[BLUE]} Level:${COLORS[RED]}${level}${COLORS[NC]}"
cycle_position=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle_position)
levels_to_next_cycle=$((8192 - ${cycle_position}))
seconds_to_next_cycle=$((levels_to_next_cycle * 8))
minutes_to_next_cycle=$((seconds_to_next_cycle / 60))
hours_to_next_cycle=$((seconds_to_next_cycle / 3600))
echo -e "\n${COLORS[BLUE]}Levels done this cycle: ${COLORS[YELLOW]}${cycle_position}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Levels to next cycle: ${COLORS[YELLOW]}${levels_to_next_cycle}${COLORS[NC]}"
echo -e "\n${COLORS[BLUE]}Minutes to next cycle: ${COLORS[PURPLE]}${minutes_to_next_cycle}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Hours to next cycle: ${COLORS[PURPLE]}${hours_to_next_cycle}${COLORS[NC]}"

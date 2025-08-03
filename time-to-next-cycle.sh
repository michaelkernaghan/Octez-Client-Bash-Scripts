#!/bin/bash
# ----------------------------------------------------------
# time-to-next-cycle.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh

# Check if required tools are available
check_octez_client
check_octez_admin_client

cycle=$(octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
level=$(octez-client rpc get /chains/main/blocks/head/header | jq '.level')
echo -e "\n${COLORS[BLUE]}Cycle:${COLORS[RED]}${cycle}${COLORS[BLUE]} Level:${COLORS[RED]}${level}${COLORS[NC]}"
cycle_position=$(octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle_position)
levels_to_next_cycle=$((BLOCKS_PER_CYCLE - ${cycle_position}))
seconds_to_next_cycle=$((levels_to_next_cycle * BLOCK_TIME_SECONDS))
minutes_to_next_cycle=$((seconds_to_next_cycle / 60))
hours_to_next_cycle=$((seconds_to_next_cycle / 3600))
echo -e "\n${COLORS[BLUE]}Levels done this cycle: ${COLORS[YELLOW]}${cycle_position}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Levels to next cycle: ${COLORS[YELLOW]}${levels_to_next_cycle}${COLORS[NC]}"
echo -e "\n${COLORS[BLUE]}Minutes to next cycle: ${COLORS[PURPLE]}${minutes_to_next_cycle}${COLORS[NC]}"
echo -e "${COLORS[BLUE]}Hours to next cycle: ${COLORS[PURPLE]}${hours_to_next_cycle}${COLORS[NC]}"
adaptive_issuance_launch_cycle=$(octez-admin-client rpc get /chains/main/blocks/head/context/adaptive_issuance_launch_cycle)
echo -e "${COLORS[BLUE]}Cycle at which the launch of the Adaptive Issuance feature is set to happen: ${COLORS[YELLOW]}${adaptive_issuance_launch_cycle}${COLORS[NC]}"

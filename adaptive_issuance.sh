#!/bin/zsh
# ----------------------------------------------------------
# adaptive_issuance.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh
source ./time-to-next-cycle.sh

# Check if required tools are available
check_octez_client
check_octez_admin_client

# Print the balances of the staker addresses
for address in "${staker_addresses[@]}"; do
    echo -e "\n${COLORS[YELLOW]}$address${COLORS[NC]}"
    balance=$(octez-client get balance for "$address")
    echo -e "${COLORS[GREEN]}Liquid balance: ${COLORS[NC]}$balance."
    staked_balance=$(octez-client get staked balance for "$address")
    echo -e "${COLORS[GREEN]}Staked balance: ${COLORS[NC]}$staked_balance."
    full_balance=$(octez-client get full balance for "$address")
    echo -e "${COLORS[GREEN]}Full balance :  ${COLORS[NC]}$full_balance."
    unstake_requests=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$address/unstake_requests/)
    echo -e "${COLORS[GREEN]}Unstake requests : \n ${COLORS[PURPLE]}$unstake_requests.${COLORS[NC]}"
    unstaked_finalizable_balance=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$address/unstaked_finalizable_balance/)
    echo -e "${COLORS[GREEN]}unstaked_finalizable_balance : \n ${COLORS[PURPLE]}$unstaked_finalizable_balance ${COLORS[NC]}"
    unstaked_frozen_balance=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$address/unstaked_frozen_balance/)
    echo -e "${COLORS[GREEN]}unstaked_frozen_balance  : \n ${COLORS[PURPLE]}$unstaked_frozen_balance ${COLORS[NC]}"
done

# Print the balance of the baker address
echo -e "\n${COLORS[PURPLE]}Baker: ${COLORS[YELLOW]}$baker_address${COLORS[NC]}"
baker_balance=$(octez-client get balance for "$baker_address")
echo -e "${COLORS[GREEN]}Liquid balance: ${COLORS[NC]}$baker_balance."
baker_staked_balance=$(octez-client get staked balance for "$baker_address")
echo -e "${COLORS[GREEN]}Staked balance: ${COLORS[NC]}$baker_staked_balance."
baker_full_balance=$(octez-client get full balance for "$baker_address")
echo -e "${COLORS[GREEN]}Full balance :  ${COLORS[NC]}$baker_full_balance."
baker_unstake_requests=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$baker_address/unstake_requests/)
echo -e "${COLORS[GREEN]}baker_unstake_requests : \n ${COLORS[PURPLE]}$baker_unstake_requests.${COLORS[NC]}"
baker_unstaked_finalizable_balance=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$baker_address/unstaked_finalizable_balance/)
echo -e "${COLORS[GREEN]}baker_unstaked_finalizable_balance : \n ${COLORS[PURPLE]}$baker_unstaked_finalizable_balance ${COLORS[NC]}"
baker_unstaked_frozen_balance=$(octez-client rpc get /chains/main/blocks/head/context/contracts/$baker_address/unstaked_frozen_balance/)
echo -e "${COLORS[GREEN]}baker_unstaked_frozen_balance  : \n ${COLORS[PURPLE]}$baker_unstaked_frozen_balance ${COLORS[NC]}"

# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Data${COLORS[NC]}"
baker_delegation_json_output=$(octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$baker_delegation_json_output" | jq

# Get the pending staking parameters
echo -e "\n${COLORS[YELLOW]}Pending Staking Parameters${COLORS[NC]}"
pending_staking_parameters=$(octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/pending_staking_parameters)
echo $pending_staking_parameters | jq

# Get the active_staking_parameters
echo -e "\n${COLORS[PURPLE]}Active Staking Parameters${COLORS[NC]}"
active_staking_parameters=$(octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/active_staking_parameters)
echo $active_staking_parameters | jq

# Get the total_frozen_stake
echo -e "\n${COLORS[PURPLE]}total_frozen_stake${COLORS[NC]}"
total_frozen_stake=$(octez-admin-client rpc get /chains/main/blocks/head/context/total_frozen_stake)
echo $total_frozen_stake | jq

# Get the adaptive_issuance_launch_cycle
echo -e "\n${COLORS[PURPLE]}adaptive_issuance_launch_cycle${COLORS[NC]}"
adaptive_issuance_launch_cycle=$(octez-admin-client rpc get /chains/main/blocks/head/context/adaptive_issuance_launch_cycle)
echo $adaptive_issuance_launch_cycle | jq

# Get issuance data
# The increase in both the `baking_reward_fixed_portion` and `liquidity_baking_subsidy` each cycle is due to the inflationary nature of the Tezos blockchain.
# 1. `baking_reward_fixed_portion`: This is the fixed portion of the reward given to bakers (validators) for creating new blocks. The increase in this reward incentivizes more participants
# to take part in the baking process, thereby helping to secure the network.
# 2. `liquidity_baking_subsidy`: This is a subsidy provided to liquidity providers who contribute to the liquidity of the Tezos blockchain.
# The increase in this subsidy is designed to incentivize more users to provide liquidity, which helps to increase the overall liquidity and stability of the Tezos ecosystem.
# The increase in these rewards each cycle is also a way to compensate for the increasing complexity and resource requirements of participating in the baking and liquidity provision processes.
# As the blockchain grows and evolves, these processes become more resource-intensive, and the rewards are increased to ensure that it remains profitable for participants.

echo -e "\n${COLORS[BLUE]}Issuance Data${COLORS[NC]}"
current_yearly_rate=$(octez-admin-client rpc get /chains/main/blocks/head/context/issuance/current_yearly_rate/)
echo -e "\n${COLORS[PURPLE]}Current Yearly Rate${COLORS[NC]}"
echo $current_yearly_rate | jq

current_yearly_rate_details=$(octez-admin-client rpc get /chains/main/blocks/head/context/issuance/current_yearly_rate_details/)
echo -e "\n${COLORS[PURPLE]}Current Yearly Rate Details${COLORS[NC]}"
echo $current_yearly_rate_details | jq

issuance_per_minute=$(octez-admin-client rpc get /chains/main/blocks/head/context/issuance/issuance_per_minute)
echo -e "\n${COLORS[PURPLE]}Issuance Per Minute${COLORS[NC]}"
echo $issuance_per_minute | jq

expected_issuance=$(octez-admin-client rpc get /chains/main/blocks/head/context/issuance/expected_issuance)
echo -e "\n${COLORS[PURPLE]}Expected Issuance${COLORS[NC]}"
echo $expected_issuance | jq

# Fetch the baking rights for the current cycle for the specified Tezos address.
# echo -e "\n${COLORS[PURPLE]}Baking Rights${COLORS[NC]}"
# baking_rights=$(octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${cycle}\&delegate=${baker_address}\&max_round=0  | jq 'map({level: .level})')
# echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: ${COLORS[NC]}${baking_rights}"

# Calculate the next cycle
# next_cycle=$((cycle+1))

# Ensure that the next cycle is a natural number before making the rpc call.
# if [[ "$next_cycle" =~ ^[0-9]+$ ]]
# then
# Fetch the baking rights for the next cycle for the baker Tezos address.
# next_baking_rights=$(octez-client rpc get /chains/main/blocks/head/helpers/baking_rights\?cycle=${next_cycle}\&delegate=${baker_address}\&max_round=0 | jq 'map({level: .level})')
# echo -e "\n${COLORS[BLUE]}Cycle ${COLORS[RED]}${next_cycle}${COLORS[BLUE]} for baker ${COLORS[YELLOW]}${baker_address}${COLORS[BLUE]}: \n${COLORS[NC]}${next_baking_rights}"
# fi

# Extract the 'baking_reward_bonus_per_slot' for the last two cycles
baking_reward_fixed_portion=$(echo "$expected_issuance" | jq '.[-1].baking_reward_fixed_portion | tonumber')
baking_reward_fixed_portion_second_last=$(echo "$expected_issuance" | jq '.[-2].baking_reward_fixed_portion | tonumber')

echo -e "\n${COLORS[BLUE]}baking_reward_fixed_portion ${COLORS[YELLOW]}${baking_reward_fixed_portion}${COLORS[NC]}"
echo -e "\n${COLORS[BLUE]}baking_reward_fixed_portion_second_last ${COLORS[YELLOW]}${baking_reward_fixed_portion_second_last}${COLORS[NC]}"

# Ensure arithmetic operations are correctly handled
if [[ $baking_reward_fixed_portion_second_last -ne 0 ]]; then
    # Calculate the percentage rate of increase
    rate_of_increase=$(echo "scale=2; 100 * ($baking_reward_fixed_portion - $baking_reward_fixed_portion_second_last) / $baking_reward_fixed_portion_second_last" | bc)
    echo "${COLORS[BLUE]}Percentage rate of increase of baking_reward_fixed_portion:${COLORS[YELLOW]} $rate_of_increase%${COLORS[NC]}"
else
    echo "Cannot calculate percentage increase due to division by zero"
fi

# Make sure these commands return JSON; you might need to add a flag or process the output differently
total_frozen_stake_output=$(octez-admin-client rpc get /chains/main/blocks/head/context/total_frozen_stake)
total_supply_output=$(octez-admin-client rpc get /chains/main/blocks/head/context/total_supply)

# Assuming the outputs are valid JSON, we directly parse them
total_frozen_stake=$(echo "$total_frozen_stake_output" | jq '. | tonumber')
total_supply=$(echo "$total_supply_output" | jq '. | tonumber')

# Check and calculate as before
if (( $(echo "$total_supply > 0" | bc -l) )); then
    staked_funds_ratio=$(echo "scale=4; $total_frozen_stake / $total_supply" | bc)
    echo "${COLORS[BLUE]}Staked funds ratio:${COLORS[YELLOW]} $staked_funds_ratio${COLORS[NC]}"
else
    echo "Invalid total_supply value: $total_supply"
fi
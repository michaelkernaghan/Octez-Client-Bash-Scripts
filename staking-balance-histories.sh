#!/bin/bash
# ----------------------------------------------------------
# adaptive_issuance.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh
cd $HOME/tezos/

staker_output_file="staker_staked_balances.csv"
if [ ! -f $staker_output_file ]; then
    echo "Cycle, Level, Address, Staked Balance" >$staker_output_file
fi
baker_output_file="baker_staked_balances.csv"
if [ ! -f $baker_output_file ]; then
    echo "Cycle, Level, Address, Staked Balance" >$baker_output_file
fi

cycle=$(./octez-admin-client rpc get /chains/main/blocks/head | jq .metadata.level_info.cycle)
level=$(octez-client rpc get /chains/main/blocks/head/header | jq '.level')

for address in "${staker_addresses[0]}"; do
    staked_balance=$(octez-client get staked balance for "$address")
    echo "$cycle, $level, $address, $staked_balance" >>$staker_output_file
done

baker_staked_balance=$(octez-client get staked balance for "$baker_address")
echo "$cycle, $level, $baker_address, $baker_staked_balance" >>$baker_output_file

echo -e "\n${COLORS[PURPLE]}Staker Staking Balance History${COLORS[NC]}"
staker_stake_balance_history=$(cat /home/mike/tezos/staker_staked_balances.csv)
cp /home/mike/tezos/staker_staked_balances.csv $HOME/Octez-Client-Bash-Scripts

echo -e "${staker_stake_balance_history}"

echo -e "\n${COLORS[PURPLE]}Baker Staking Balance History${COLORS[NC]}"
baker_stake_balance_history=$(cat /home/mike/tezos/baker_staked_balances.csv)
cp /home/mike/tezos/baker_staked_balances.csv $HOME/Octez-Client-Bash-Scripts
echo -e "${baker_stake_balance_history}"

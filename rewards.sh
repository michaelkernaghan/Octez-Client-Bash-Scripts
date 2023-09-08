#!/bin/bash
# ----------------------------------------------------------
# adaptive_issuance.sh
# Michael Kernaghan
#-----------------------------------------------------------

source ./common.sh
source ./time-to-next-cycle.sh

cd $HOME/tezos/

echo -e "\n${COLORS[BLUE]}Issuance Data${COLORS[NC]}"
current_yearly_rate=$(./octez-admin-client rpc get /chains/main/blocks/head/context/issuance/current_yearly_rate/)
echo "current yearly rate: ${current_yearly_rate}" 

current_yearly_rate_exact=$(./octez-admin-client rpc get /chains/main/blocks/head/context/issuance/current_yearly_rate_exact/)
echo "current yearly rate exact: ${current_yearly_rate_exact}" 

issuance_per_minute=$(./octez-admin-client rpc get /chains/main/blocks/head/context/issuance/issuance_per_minute)
echo "issuance_per_minute: ${issuance_per_minute}"

expected_issuance=$(./octez-admin-client rpc get /chains/main/blocks/head/context/issuance/expected_issuance)
echo "expected_issuance: ${expected_issuance}"

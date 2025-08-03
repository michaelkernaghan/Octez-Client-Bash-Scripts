#!/bin/bash
source ./common.sh
cd $HOME/tezos/

baker_address="tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"

level1=$(octez-client rpc get /chains/main/blocks/head/header | jq '.level')

# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Data at level ${COLORS[RED]}${level1}${COLORS[NC]}"
response1=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$response1" | jq

# Wait  fo 5  levels
sleep 40

# Second call
level2=$(octez-client rpc get /chains/main/blocks/head/header | jq '.level')
# Get the baker delegation information
echo -e "\n${COLORS[BLUE]}Baker Data at level ${COLORS[RED]}${level2}${COLORS[NC]}"
response2=$(./octez-admin-client rpc get /chains/main/blocks/head/context/delegates/${baker_address}/)
echo "$response2" | jq

# Compare the two responses using jq
diff=$(jq -n --argjson a "$response1" --argjson b "$response2" 'def post_recurse(f): def r: (f | select(. != null) | r), .; r; def post_recurse: post_recurse(.[]?); ($a | (post_recurse | arrays) |= sort) as $a | ($b | (post_recurse | arrays) |= sort) as $b | $a == $b')

# Print the differences
if [ "$diff" = "false" ]
then
    echo "There are differences."
else
    echo "There are no differences."
fi

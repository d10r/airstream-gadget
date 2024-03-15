#!/bin/bash

# usage: ./deploy.sh network_name contract_name
#         env var PRIVKEY must be set

set -eu

source .env

network_name=$1
# assumption: contract is located in src/<contract_name>.sol
contract_name=$2

# get network metadata
metadata=$(curl -s "https://raw.githubusercontent.com/superfluid-finance/protocol-monorepo/dev/packages/metadata/networks.json")
network=$(echo "$metadata" | jq -r '.[] | select(.name == "'$network_name'")')

# verify chain id
rpc_url=${RPC:-"https://$network_name.rpc.x.superfluid.dev?app=deployer"}
connected_chain_id_hex=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' $rpc_url | jq -r '.result')
connected_chain_id=$(printf "%d" $connected_chain_id_hex)
expected_chain_id=$(echo "$network" | jq -r '.chainId')
if [ "$connected_chain_id" != "$expected_chain_id" ]; then
    echo "chain id mismatch: expected $expected_chain_id, connected to $connected_chain_id"
    exit 1
fi

# get explorer api key
explorer_url=$(echo "$network" | jq -r '.explorer')
explorer_api_key_name=$(echo $explorer_url | sed -E 's|https://(.*)\..*|\U\1_API_KEY|g' | sed 's/\./_/g' | sed 's/\-/_/g')
fallback_explorer_api_key_name=$(echo $explorer_api_key_name | sed 's/^[^_]*_//')
explorer_api_key=${!explorer_api_key_name:-${!fallback_explorer_api_key_name}}

forge create --rpc-url $rpc_url --private-key=$PRIVKEY --etherscan-api-key $explorer_api_key --verify src/$contract_name.sol:$contract_name

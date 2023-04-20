#!/bin/bash


CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"

rm -rf ~/.zetacored/
zetacored init Zetanode --chain-id=$CHAINID
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="azeta"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="azeta"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="azeta"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="azeta"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["evm"]["params"]["evm_denom"]="azeta"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json
cat $HOME/.zetacored/config/genesis.json | jq '.app_state["gov"]["voting_params"]["voting_period"]="10s"' > $HOME/.zetacored/config/tmp_genesis.json && mv $HOME/.zetacored/config/tmp_genesis.json $HOME/.zetacored/config/genesis.json

cp -a genesis_files/os_info/. ~/.zetacored/os_info/
cp -a genesis_files/gentx/. ~/.zetacored/config/gentx/

zetacored collect-observer-info
zetacored add-observer-list
zetacored collect-gentxs
zetacored validate-genesis

zetacored start --trace \
--minimum-gas-prices=0.0001azeta \
--json-rpc.api eth,txpool,personal,net,debug,web3,miner \
--api.enable >> ~/.zetacored/zetacored.log 2>&1  &

sleep 6
latest_block_height=$(curl --request GET -sL --url 'localhost:26657/status' --header 'Content-Type: application/json' | jq '.result.sync_info.latest_block_height|tonumber')

echo "latest_block_height: $latest_block_height"
if [ "$latest_block_height" -ge 0 ]; then
    echo "gentx and OS_INFO files are valid"
else
    echo "gentx or OS_INFO files are inValid"
    exit 1
fi

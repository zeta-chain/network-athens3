#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"

rm -rf ~/.zetacored/os_info/*
rm -rf ~/.zetacored/config/gentx/*


cp -a genesis_files/os_info/. ~/.zetacored/os_info/
cp -a genesis_files/gentx/. ~/.zetacored/config/gentx/


cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="azeta"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="azeta"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="azeta"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="azeta"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["evm"]["params"]["evm_denom"]="azeta"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json
cat "$HOME"/.zetacored/config/genesis.json | jq '.app_state["gov"]["voting_params"]["voting_period"]="10s"' > "$HOME"/.zetacored/config/tmp_genesis.json && mv "$HOME"/.zetacored/config/tmp_genesis.json "$HOME"/.zetacored/config/genesis.json


zetacored collect-observer-info
zetacored add-observer-list --keygen-block=100
zetacored collect-gentxs
zetacored validate-genesis
rm -rf network_files/config/genesis.json
cp ~/.zetacored/config/genesis.json ./network_files/config/
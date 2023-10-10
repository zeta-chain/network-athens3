#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)

rm -rf ~/.zetacored/data/*
mkdir -p ~/.zetacored/data
cp -a network_files/data/priv_validator_state.json ~/.zetacored/data/

rm -rf ~/.zetacored/config/addrbook.json

rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/

zetacored start --pruning=nothing --minimum-gas-prices=0.0001azeta --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable >> ~/.zetacored/zetacored.log 2>&1  &
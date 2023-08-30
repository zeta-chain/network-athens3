#!/bin/bash

rm -rf ~/.zetacored/data/*
cp -a network_files/data/*.json ~/.zetacored/data/

rm -rf ~/.zetacored/config/addrbook.json

rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/

#zetacored start --pruning=nothing --minimum-gas-prices=0.0001azeta --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable

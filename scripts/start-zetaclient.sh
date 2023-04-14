#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)


operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"
echo "Start zetaclientd"
rm ~/.tss/*
export TSSPATH=~/.tss
zetaclientd init --enable-chains "goerli_localnet" \
  --pre-params ~/preParams.json \
  --chain-id athens_101-1 --dev --operator "$operatorAddress" --log-level 0 --hotkey=hotkey --keygen-block 30
zetaclientd start
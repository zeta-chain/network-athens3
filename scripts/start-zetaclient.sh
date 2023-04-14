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
  --chain-id $CHAINID --dev --operator "$operatorAddress" --log-level 0 --hotkey=hotkey --keygen-block 100
zetaclientd start ~/.zetacored/zetaclient.log 2>&1  &

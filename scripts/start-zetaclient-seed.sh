#!/bin/bash
CHAINID="devnet_6001-1"
KEYRING="test"

HOSTNAME=$(hostname)
MYIP=$(curl ifconfig.me)
operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

zetaclientd init --operator "$operatorAddress" --public-ip "$MYIP" --chain-id "$CHAINID"
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &


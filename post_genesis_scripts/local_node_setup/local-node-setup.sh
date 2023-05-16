#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
peerip=""
peername=""
rm -rf ~/.zetacored
zetacored init Zetanode-LocalNode --chain-id=$CHAINID
rm -rf ~/.zetacored/config/genesis.json

curl $peerip:26657/genesis | jq .result.genesis > ~/.zetacored/config/genesis.json
pp=$peername@$peerip:26656
sed -i -e "/persistent_peers =/s/=.*/= \"$pp\"/" "$HOME"/.zetacored/config/config.toml
zetacored start


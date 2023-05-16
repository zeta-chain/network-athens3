#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"

rm -rf ~/.zetacored
zetacored init Zetanode-LocalNode --chain-id=$CHAINID
rm -rf ~/.zetacored/config/genesis.json

curl 34.239.99.239:26657/genesis | jq .result.genesis > ~/.zetacored/config/genesis.json
pp=af58c82b5f4d2268e0b8ca9150190e438c07d90d@34.239.99.239:26656,038234610497601373b1d27e27251674c6c81df7@3.218.170.198:26656
sed -i -e "/persistent_peers =/s/=.*/= \"$pp\"/" "$HOME"/.zetacored/config/config.toml
zetacored start

#sed -i -e "/seeds =/s/=.*/= \"$pp\"/" "$HOME"/.zetacored/config/config.toml
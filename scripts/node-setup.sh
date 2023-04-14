#!/bin/bash



rm -rf ~/.zetacored
# create keys
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"

# Init a new node to generate genesis file .
# Copy config files from existing folders which get copied via Docker Copy when building images
zetacored init Zetanode_HOSTNAME --chain-id=$CHAINID
rm -rf ~/.zetacored/config/config.toml
rm -rf ~/.zetacored/config/app.toml
rm -rf ~/.zetacored/config/client.toml
cp -a network_files/config/. ~/.zetacored/config/

zetacored keys add operator --algo=secp256k1 --keyring-backend=$KEYRING
zetacored keys add hotkey --algo=secp256k1 --keyring-backend=$KEYRING
operator_address=$(zetacored keys show operator -a --keyring-backend=$KEYRING)
hotkey_address=$(zetacored keys show hotkey -a --keyring-backend=$KEYRING)
#pubkey=$(zetacored get-pubkey hotkey|sed -e 's/secp256k1:"\(.*\)"/\1/' | sed 's/ //g' )
echo "operator_address: $operator_address"
echo "hotkey_address: $hotkey_address"
#echo "pubkey: $pubkey"
pubkey=hotkey_address
mkdir ~/.zetacored/os_info
jq -n --arg operator_address "$operator_address" --arg hotkey_address "$hotkey_address" --arg pubkey "$pubkey" '{"ObserverAddress":$operator_address,"ZetaClientGranteeAddress":$hotkey_address,"ZetaClientGranteePubKey":$pubkey}' > ~/.zetacored/os_info/os.json
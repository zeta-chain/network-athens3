#!/bin/bash

now=zetacored-$(date +"%T")
mkdir -p ~/.zetacored-old/$now
cp -a ~/.zetacored/* ~/.zetacored-old/$now/
rm -rf ~/.zetacored
# create keys
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"

# Init a new node to generate genesis file .
# Copy config files from existing folders which get copied via Docker Copy when building images
zetacored init Zetanode_HOSTNAME --chain-id=$CHAINID

#Clean main folder
rm -rf genesis_files/gentx/*.json
rm -rf genesis_files/os_info/*.json

#Clean node folder and backup default genesis file
rm -rf ~/.zetacored/config/config.toml
rm -rf ~/.zetacored/config/app.toml
rm -rf ~/.zetacored/config/client.toml
cp -a network_files/config/. ~/.zetacored/config/
mkdir -p ~/.backup/config/
cp -a ~/.zetacored/config/genesis.json ~/.backup/config/

# Add moniker to confiog file
pp=$(cat $HOME/.zetacored/config/gentx/z2gentx/*.json | jq '.body.memo' )
pps=Zetanode_$HOSTNAME
sed -i -e "/moniker =/s/=.*/= \"$pps\"/" "$HOME"/.zetacored/config/config.toml

# add keys and genenerate os_info.jso
zetacored keys add operator --algo=secp256k1 --keyring-backend=$KEYRING
zetacored keys add hotkey --algo=secp256k1 --keyring-backend=$KEYRING
operator_address=$(zetacored keys show operator -a --keyring-backend=$KEYRING)
hotkey_address=$(zetacored keys show hotkey -a --keyring-backend=$KEYRING)
pubkey=$(zetacored get-pubkey hotkey|sed -e 's/secp256k1:"\(.*\)"/\1/' | sed 's/ //g' )
echo "operator_address: $operator_address"
echo "hotkey_address: $hotkey_address"
echo "pubkey: $pubkey"
mkdir ~/.zetacored/os_info
jq -n --arg operator_address "$operator_address" --arg hotkey_address "$hotkey_address" --arg pubkey "$pubkey" '{"ObserverAddress":$operator_address,"ZetaClientGranteeAddress":$hotkey_address,"ZetaClientGranteePubKey":$pubkey}' > ~/.zetacored/os_info/os.json
mkdir -p genesis_files/os_info
cp ~/.zetacored/os_info/os.json ./genesis_files/os_info/os_$HOSTNAME.json

# Add balances to genesis file and create GenTX
zetacored collect-observer-info
zetacored add-observer-list
zetacored gentx operator 1000000000000000000000azeta --chain-id=$CHAINID --keyring-backend=$KEYRING
mkdir -p genesis_files/gentx
cp ~/.zetacored/config/gentx/* ./genesis_files/gentx/

# Remove genesis file with balances and replace with original genesis file
rm -rf ~/.zetacored/config/genesis.json
cp -a ~/.backup/config/genesis.json ~/.zetacored/config/

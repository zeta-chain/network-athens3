!/bin/bash

# create keys
CHAINID="athens_7001-1"
KEYRING="test"
MONIKER=$(grep moniker ~/.zetacored/config/config.toml | sed 's/moniker = \"\(.*\)\"/\1/')
echo "MONIKER: $MONIKER"

# Reset node
rm ~/.zetacored/config/genesis.json
zetacored keys delete operator -y
zetacored keys delete hotkey -y
rm -rf ~/.zetacored/os_info
rm -rf ~/.zetacored/config/gentx

# Init a new node to generate genesis file .
zetacored init $MONIKER --chain-id=$CHAINID
echo "zetacored init $MONIKER --chain-id=$CHAINID"

# add keys and genenerate os_info.json
zetacored keys add operator --algo=secp256k1 --keyring-backend=$KEYRING
zetacored keys add hotkey --algo=secp256k1 --keyring-backend=$KEYRING
operator_address=$(zetacored keys show operator -a --keyring-backend=$KEYRING)
hotkey_address=$(zetacored keys show hotkey -a --keyring-backend=$KEYRING)
pubkey=$(zetacored get-pubkey hotkey|sed -e 's/secp256k1:"\(.*\)"/\1/' | sed 's/ //g' )
echo "operator_address: $operator_address"
echo "hotkey_address: $hotkey_address"
echo "pubkey: $pubkey"
mkdir ~/.zetacored/os_info

jq -n --arg IsObserver "y" --arg operator_address "$operator_address" --arg hotkey_address "$hotkey_address" --arg pubkey "$pubkey" '{"IsObserver":$IsObserver,"ObserverAddress":$operator_address,"ZetaClientGranteeAddress":$hotkey_address,"ZetaClientGranteePubKey":$pubkey}' > ~/.zetacored/os_info/os.json
cp ~/.zetacored/os_info/os.json ./genesis_files/os_info/os_"$MONIKER".json

# Add balances to genesis file and create GenTX
zetacored collect-observer-info
zetacored add-observer-list
zetacored gentx operator 1000000000000000000000azeta --chain-id=$CHAINID --keyring-backend=$KEYRING
cp ~/.zetacored/config/gentx/* ./genesis_files/gentx/


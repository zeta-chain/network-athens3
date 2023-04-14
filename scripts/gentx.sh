HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"
CHAINID="athens_7001-1"
KEYRING="test"

rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/
zetacored gentx operator 1000000000000000000000azeta --chain-id=$CHAINID --keyring-backend=$KEYRING
mkdir -p genesis_files/gentx
cp ~/.zetacored/config/gentx/* ./genesis_files/gentx/
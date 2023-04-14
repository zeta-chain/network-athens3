HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"
CHAINID="athens_7001-1"
KEYRING="test"

rm -rf ~/.zetacored/config/gentx/*
cp -a genesis_files/gentx/* ~/.zetacored/config/gentx/
zetacored collect-gentxs
zetacored validate-genesis
rm -rf network_files/config/genesis.json
cp ~/.zetacored/config/genesis.json ./network_files/config/
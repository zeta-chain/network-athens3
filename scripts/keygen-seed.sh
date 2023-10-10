#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"

HOSTNAME=$(hostname)


echo "Kill all zetacored---------->"
killall zetacored
killall zetaclientd
echo "Cleaning data---------->"
rm -rf ~/.tss/address_book.seed
rm -rf ~/.zetacored/data/snapshots
rm -rf ~/.zetacored/data/cs.wal
rm -rf ~/.zetacored/data/*.db
rm -rf ~/.zetacored/config/addrbook.json
rm -rf ~/.zetacored/data/priv_validator_state.json
echo "Create new priv_validator_state.json---------->"
echo '{"height":"0","round":0,"step":0}' | jq . > ~/.zetacored/data/priv_validator_state.json

echo "Copy genesis.json to ~/.zetacored/config/---------->"
rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/
echo "Start zetacored---------->"
zetacored start --pruning=nothing --minimum-gas-prices=0.0001azeta --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable >> ~/.zetacored/zetacored.log 2>&1  &
sleep 15
MYIP=$(curl ifconfig.me)
operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

zetaclientd init --operator "$operatorAddress" --public-ip "$MYIP"
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &
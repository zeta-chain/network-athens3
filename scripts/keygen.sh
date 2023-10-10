#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"

HOSTNAME=$(hostname)

clibuilder()
{
   echo ""
   echo "Usage: $0 -s SEEDIP"
   echo -e "\t-s SEEDIP"
   exit 1 # Exit script after printing help
}

while getopts "s:" opt
do
   case "$opt" in
      s ) SEEDIP="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$SEEDIP" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi


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
sleep 45

MYIP=$(curl ifconfig.me)

echo "SEEDIP: $SEEDIP"
export SEED=$(curl --retry 10 --retry-delay 5 --retry-connrefused  -s "$SEEDIP":8123/p2p)
peer=/ip4/"$SEEDIP"/tcp/6668/p2p/"$SEED"
operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

zetaclientd init --peer "$peer" --operator "$operatorAddress" --public-ip "$MYIP"
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &

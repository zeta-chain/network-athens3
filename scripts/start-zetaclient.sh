#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)


clibuilder()
{
   echo ""
   echo "Usage: $0 -s SEEDIP -k KeygenBlock"
   echo -e "\t-s SEEDIP"
   echo -e "\t-k Keygen Block for zetaclient"
   exit 1 # Exit script after printing help
}

while getopts "k:s:" opt
do
   case "$opt" in
      k ) KeygenBlock="$OPTARG" ;;
      s ) SEEDIP="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$KeygenBlock" ] || [ -z "$SEEDIP" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi


export MYIP=$(curl ifconfig.me)
export SEEDIP=$SEEDIP
echo "SEEDIP: $SEEDIP"
echo "KeygenBlock: $KeygenBlock"
export SEED=$(curl --retry 10 --retry-delay 5 --retry-connrefused  -s $SEEDIP:8123/p2p)
export TSSPATH=~/.tss

operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

rm ~/.tss/*
zetaclientd init --enable-chains "goerli_testnet,btc_testnet" \
  --pre-params ~/preParams.json \
  --peer /ip4/$SEEDIP/tcp/6668/p2p/$SEED \
  --chain-id $CHAINID --dev --operator "$operatorAddress" --log-level 0 --hotkey=hotkey --keygen-block $KeygenBlock
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &

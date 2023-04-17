#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)


clibuilder()
{
   echo ""
   echo "Usage: $0 -k KeygenBlock"
   echo -e "\t-k Keygen Block for zetaclient"
   exit 1 # Exit script after printing help
}

while getopts "k:" opt
do
   case "$opt" in
      k ) KeygenBlock="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$KeygenBlock" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi



echo "KeygenBlock: $KeygenBlock"
operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"
echo "Start zetaclientd"
rm ~/.tss/*
export TSSPATH=~/.tss
zetaclientd init --enable-chains "goerli_localnet" \
  --pre-params ~/preParams.json \
  --chain-id $CHAINID --dev --operator "$operatorAddress" --log-level 0 --hotkey=hotkey --keygen-block $KeygenBlock
zetaclientd start ~/.zetacored/zetaclient.log 2>&1  &

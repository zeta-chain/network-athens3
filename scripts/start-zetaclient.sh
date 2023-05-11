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

if [ -z "${MYIP}" ]; then 
    echo "MYIP ENV Variable Not Set -- Setting it automatically using host IP"
    export MYIP=$(curl ifconfig.me)
fi

echo "SEEDIP: $SEEDIP"
export SEED=$(curl --retry 10 --retry-delay 5 --retry-connrefused  -s "$SEEDIP":8123/p2p)
export TSSPATH=~/.tss

operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

rm ~/.tss/*
zetaclientd init \
  --pre-params ~/preParams.json \
  --peer /ip4/"$SEEDIP"/tcp/6668/p2p/"$SEED" \
  --chain-id $CHAINID --operator "$operatorAddress" --log-level 0 --hotkey=hotkey
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &

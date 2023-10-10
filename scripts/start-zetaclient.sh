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


MYIP=$(curl ifconfig.me)

echo "SEEDIP: $SEEDIP"
export SEED=$(curl --retry 10 --retry-delay 5 --retry-connrefused  -s "$SEEDIP":8123/p2p)
peer=/ip4/"$SEEDIP"/tcp/6668/p2p/"$SEED"
operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

zetaclientd init --peer "$peer" --operator "$operatorAddress" --public-ip "$MYIP" --chain-id "$CHAINID"
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &


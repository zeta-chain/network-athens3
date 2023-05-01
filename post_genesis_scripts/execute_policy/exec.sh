#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)

clibuilder()
{
   echo ""
   echo "Usage: $0 -i ProposalID"
   echo -e "\t-i ProposalID"
   exit 1 # Exit script after printing help
}

while getopts "i:" opt
do
   case "$opt" in
      i ) PID="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$PID" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi

zetacored tx group exec "$PID" --from zeta --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block

#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
signer="val0_op_usw1"
nodeip="3.218.170.198"
node=tcp://$nodeip:26657

signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"


clibuilder()
{
   echo ""
   echo "Usage: $0 -i proposalID"
   echo -e "\t-i proposalID"
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

zetacored tx gov vote "$PID" no --from $signer --keyring-backend $KEYRING --chain-id $CHAINID --yes --gas=auto --gas-adjustment=1.5 --gas-prices=0.01azeta --broadcast-mode=block --node=$node

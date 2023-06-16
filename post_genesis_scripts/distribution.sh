#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
nodeip="3.218.170.198"
node=tcp://$nodeip:26657



clibuilder()
{
   echo ""
   echo "Usage: $0 -s Signer -a Amount"
   echo -e "\t-s Name of account distributing funds"
   echo -e "\t-a Amount distributed to each node"
   exit 1 # Exit script after printing help
}

while getopts "s:a:" opt
do
   case "$opt" in
      s ) SignerName="$OPTARG" ;;
      a ) Amount="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$SignerName" ] || [ -z "$Amount" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi




signerAddress=$(zetacored keys show $SignerName -a --keyring-backend=test)
echo "signerAddress: $signerAddress"

operators=()
while IFS= read -r line; do
    operators+=( "$line" )
done < <( zetacored q crosschain list-node-account --node=tcp://3.218.170.198:26657 --output=json | jq -r ".NodeAccount[].operator" )

echo "operators: ${operators[@]}"
zetacored tx bank multi-send "$signerAddress" "${operators[@]}" $Amount --keyring-backend $KEYRING --chain-id $CHAINID --yes --broadcast-mode=sync --gas=auto --gas-adjustment=2 --gas-prices=0.00001azeta --node=$node








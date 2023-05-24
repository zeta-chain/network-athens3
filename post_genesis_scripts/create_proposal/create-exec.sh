#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
signer=""
nodeip="3.218.170.198"
node=tcp://$nodeip:26657
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

signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"


zetacored tx group submit-proposal post_genesis_scripts/create_proposal/proposal_keygen.json --from $signer --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block --node=$node
sleep 5
zetacored tx group vote "$PID" $signerAddress VOTE_OPTION_YES metadata --from $signer --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block --node=$node
sleep 5
zetacored tx group exec "$PID" --from $signer --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block --node=$node



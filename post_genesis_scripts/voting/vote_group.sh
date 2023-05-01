#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)


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

hotkeyAddress=$(zetacored keys show hotkeyAddress -a --keyring-backend=test)
echo "hotkeyAddress: $hotkeyAddress"
# shellcheck disable=SC2086
zetacored tx group vote "$PID" $hotkeyAddress VOTE_OPTION_YES metadata --from zeta --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block

#!/bin/bash

clibuilder()
{
   echo ""
   echo "Usage: $0 -o Observer Flag"
   echo -e "\t-o Set to y to run observer-validater , set to n to run validater only. Note this value is case sensitive"
   exit 1 # Exit script after printing help
}

while getopts "o:" opt
do
   case "$opt" in
      o ) is_observer="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$is_observer" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi



# Ask for confirmation
read -p "This script should only be used during the initial setup. 
It will DELETE EXISTING config files and keys if used a second time.
It will remove the contents of ~/.zetacored.
Are you sure you want to continue? (y/n) " confirm

# Check user input
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "Continuing with the node-setup script..."
else
    echo "Aborting..."
    exit 1
fi



echo You must set a moniker for this validator
# Get user input
read -p "Enter the moniker for this validator: " input

# Print input and confirm
echo "You entered: $input"
read -p "Is this correct? [Y/n] " confirm

# Check confirmation
if [[ $confirm =~ ^[Yy]$ ]]; then
    echo "Confirmed!"
else
    echo "Aborted."
    exit 1
fi

# Replace moniker
moniker=$input




if [[ "$is_observer" = "y" ||"$is_observer" == "n" ]]; then
  echo "Validator only flag value : $is_observer"
else
  echo "Please use only y or n for -v flag.This value is casesensitive"
  exit 1
fi


now=zetacored-$(date +"%T")
mkdir -p ~/.zetacored-old/"$now"

if [ -d "$HOME/.zetacored" ]
then
    echo "Creating a backup of existing config files and keys in ~/.zetacored-old/$now"
    cp -a ~/.zetacored/* ~/.zetacored-old/"$now"/
fi

rm -rf ~/.zetacored/config
rm -rf ~/.zetacored/data
rm -rf ~/.zetacored/keyring*
rm -rf ~/.zetacored/os_info


# create keys
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
echo "HOSTNAME: $HOSTNAME"


# Init a new node to generate genesis file .
# Copy config files from existing folders which get copied via Docker Copy when building images
zetacored init "$moniker" --chain-id="$CHAINID"

#Clean main folder
rm -rf genesis_files/gentx/*.json
rm -rf genesis_files/os_info/*.json

#Clean node folder and backup default genesis file
rm -rf ~/.zetacored/config/config.toml
rm -rf ~/.zetacored/config/app.toml
rm -rf ~/.zetacored/config/client.toml
cp -a network_files/config/. ~/.zetacored/config/
mkdir -p ~/.backup/config/
cp -a ~/.zetacored/config/genesis.json ~/.backup/config/

# Add moniker to config file
pps="$moniker"
sed -i -e "/moniker =/s/=.*/= \"$pps\"/" "$HOME"/.zetacored/config/config.toml

# add keys and genenerate os_info.json
zetacored keys add operator --algo=secp256k1 --keyring-backend=$KEYRING
zetacored keys add hotkey --algo=secp256k1 --keyring-backend=$KEYRING
operator_address=$(zetacored keys show operator -a --keyring-backend=$KEYRING)
hotkey_address=$(zetacored keys show hotkey -a --keyring-backend=$KEYRING)
pubkey=$(zetacored get-pubkey hotkey|sed -e 's/secp256k1:"\(.*\)"/\1/' | sed 's/ //g' )
echo "operator_address: $operator_address"
echo "hotkey_address: $hotkey_address"
echo "pubkey: $pubkey"
echo "is_observer: $is_observer"
mkdir ~/.zetacored/os_info
jq -n --arg is_observer "$is_observer" --arg operator_address "$operator_address" --arg hotkey_address "$hotkey_address" --arg pubkey "$pubkey" '{"IsObserver":$is_observer,"ObserverAddress":$operator_address,"ZetaClientGranteeAddress":$hotkey_address,"ZetaClientGranteePubKey":$pubkey}' > ~/.zetacored/os_info/os.json
mkdir -p genesis_files/os_info
cp ~/.zetacored/os_info/os.json ./genesis_files/os_info/os_"$HOSTNAME".json

# Add balances to genesis file and create GenTX
zetacored collect-observer-info
zetacored add-observer-list
zetacored gentx operator 1000000000000000000000azeta --chain-id=$CHAINID --keyring-backend=$KEYRING
mkdir -p genesis_files/gentx
cp ~/.zetacored/config/gentx/* ./genesis_files/gentx/

# Remove genesis file with balances and replace with original genesis file
rm -rf ~/.zetacored/config/genesis.json
cp -a ~/.backup/config/genesis.json ~/.zetacored/config/

#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)

if grep -q 'moniker = ""' network_files/config/config.toml; then
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
    sed -i "s/moniker = \"test\"/moniker = \"$input\"/g" network_files/config/config.toml
fi

rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/
zetacored start --pruning=nothing --minimum-gas-prices=0.0001azeta --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable >> ~/.zetacored/zetacored.log 2>&1  &
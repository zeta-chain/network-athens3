#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
signer="operator"

signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"
zetacored tx gov submit-legacy-proposal param-change post_genesis_scripts/create_group/proposal.json --from $signer --gas=auto --gas-adjustment=1.5 --gas-prices=0.001azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block
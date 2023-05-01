#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)

zetacored tx gov submit-legacy-proposal param-change post_genesis_scripts/create_group/proposal.json --from zeta --gas=auto --gas-adjustment=1.5 --gas-prices=0.1azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block
#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)



zetacored tx  group create-group-with-policy zeta1syavy2npfyt9tcncdtsdzf7kny9lh777heefxk group-metadata group-policy-metadata members.json policy.json --from hotkey --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block
zetacored tx group submit-proposal proposal_group.json --from zeta --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block



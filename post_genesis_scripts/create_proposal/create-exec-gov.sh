#!/bin/bash
CHAINID="athens_7001-1"
KEYRING="test"
HOSTNAME=$(hostname)
signer="val0_op_se"
nodeip="3.218.170.198"
node=tcp://$nodeip:26657


signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"


zetacored tx gov submit-legacy-proposal param-change proposal_test_params.json --from $signer --chain-id=$CHAINID --keyring-backend=$KEYRING -y --node=$node --broadcast-mode=block --gas=auto --gas-adjustment=1.5 --gas-prices=0.001azeta
#zetacored tx gov deposit 3 10000000azeta --from $signer --gas=auto --gas-adjustment=1.5 --gas-prices=0.01azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --node=$node --broadcast-mode=block
#zetacored tx bank send $signerAddress zeta1utsn7w4dzluh026ylwkntmtc4jrpn2393nsggp 10zeta --gas=auto --gas-adjustment=1.5 --gas-prices=0.01azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --node=$node --broadcast-mode=block


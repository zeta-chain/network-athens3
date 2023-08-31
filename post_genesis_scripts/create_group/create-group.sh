#!/usr/bin/env bash
source ../../config/config.shlib
echo "$(config_get nodeip)"; # will be found in user-cfg

chainID="$(config_get CHAINID)"; # how to just read a value without echoing
echo "$(config_get othervar)"; # will fall back to defaults

exit

signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"

zetacored tx  group create-group-with-policy "$signerAddress" group-metadata group-policy-metadata post_genesis_scripts/create_group/members.json post_genesis_scripts/create_group/policy_threshold.json --from $signer --gas=auto --gas-adjustment=1.5 --gas-prices=0.001azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block
zetacored q group group-policies-by-group 1 --node=$node




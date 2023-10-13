pkill zetacored
git pull
make install-testnet
rm -rf /usr/local/bin/zetacored
cp ~/go/bin/zetacored  /usr/local/bin/
zetacored start --pruning=nothing --minimum-gas-prices=0.0001azeta --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable >> ~/.zetacored/zetacored.log 2>&1  &


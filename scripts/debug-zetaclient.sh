killall zetaclientd
git pull
make install-testnet
rm -rf /usr/local/bin/zetaclientd
cp ~/go/bin/zetaclientd  /usr/local/bin/
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &
tail -f ~/.zetacored/zetaclient.log


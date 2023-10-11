rm -rf /usr/local/bin/zetacored
cp ~/go/bin/bin/zetacored  /usr/local/bin/
rm -rf /usr/local/bin/zetaclientd
cp ~/go/bin/bin/zetaclientd  /usr/local/bin/

rm -rf /usr/local/bin/zetaclientd
cp ~/go/bin/zetaclientd  /usr/local/bin/
rm -rf /usr/local/bin/zetacored
cp ~/go/bin/zetacored  /usr/local/bin/

curl -X 'GET' \
  'https://localhost:1317/zeta-chain/crosschain/pendingNonces' \
  -H 'accept: application/json'

https://18.211.188.24:1317/zeta-chain/crosschain/pendingNonces
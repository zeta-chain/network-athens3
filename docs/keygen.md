## Keygen Ceremony


During the genesis process of the Athens3 testnet, 
the TSS Signers (validators who are in the set of TSSSigner)
would need to generate a TSS public key and key fragments
(the `keygen` ceremony).

For the `keygen` ceremony all TSS signers need to be online
at the same time, and all TSS signers need to specify the same
`--keygen-block <block num>`. The keygen ceremony will begin
at block `<block num>`. 

First, replace with your own operator key

```bash
$ rm ~/.tss/address_book.seed
$ export TSSPATH=~/.tss
$ zetaclientd init --val val --log-console --enable-chains "goerli_testnet,bsc_testnet" \
    --chain-id athens_7001-1 --dev --operator zeta1z46tdw75jvh4h39y3vu758ctv34rw5z9kmyhgz --log-level 0 \
    --keygen-block 15000
```

and then

```bash
$ zetaclientd start
```
# Athens 3 Validator Setup guide

The ZetaChan Genesis process for Athens3 is broken up into three phases:

Phase 1: Local Setup

- Setup your validator node
- Generate keys
- Submit keys to the coordinator via GitHub PR

Phase 2: Core Genesis

- Wait for updated genesis file to be provided by the coordinator
- Start zetacored
- Wait for the coordinator to confirm network genesis is complete

Phase 3: TSS Keygen (Observer/Signer Validators Only)

- Wait for the coordinator to provide the TSS keygen block and SEED IP
- Start zetaclientd
- Wait for the coordinator to confirm TSS keygen is complete

## Phase 1: Local Setup

### Node Setup

Here we assume a typical Ubuntu 22.04 LTS x86_64 setup. If you are using a
different OS you may need to make some adjustments. For more information about
the compute node requirement see [here](node_requirements.md)

#### Make sure `jq`, `git`, `curl`, and `make` are installed.

```bash
sudo apt update
sudo apt install -y jq curl git
jq --version
```

#### Download and install `zetacored` and `zetaclientd` binaries
Binaries are built based on OS version and CPU architecture. The binaries follow this format

`zetacored-ubuntu-[20,22]-[arm64,amd64]`

For the rest of these instructions we'll assume you are usinng Ubuntu 22 with
`amd64` architecture. If you are using a different OS or CPU architecture you'll
need to adjust the commands below.
```
wget https://zetachain-external-files.s3.amazonaws.com/binaries/athens3/latest/zetacored-ubuntu-22-amd64
wget https://zetachain-external-files.s3.amazonaws.com/binaries/athens3/latest/zetaclientd-ubuntu-22-amd64
mv zetacored-ubuntu-22-amd64 /usr/bin/zetacored && chmod +x /usr/bin/zetacored
mv zetaclientd-ubuntu-22-amd64 /usr/bin/zetaclientd && chmod +x /usr/bin/zetaclientd
# You may need to set additional permissions depending on your node configuration
```

#### Clone the network GitHub repository

```bash
git clone https://github.com/zeta-chain/network-athens3.git && cd network-athens3
```

#### Run The Node Setup Script

Give execute permissions to the scripts and run the node setup script.

When prompted for confirm, enter `y` to continue.

For observer validators
```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh -o y
```
For non-observer validators
```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh -o n
```

After the `node-setup.sh` script generates the keys and necessary files, create
a branch, commit, and raise a PR to submit the files to ZetaChain coordinator:

- Use `gen-files-<YourValidatorName>` as the branch name for the new branch.
- The pr must contain only two files
  - `os_info.json`
  - `gentx-XX.json`
- Do not commit `network_files/config/genesis.json` if it exists
  - This file can be deleted, it is not required.
- An automated GitHub Action will validator your PR
- Your PR must pass this check before the coordinator will merge it

NOTE : A backup up is created for the existing zetacored folder under
`~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .

## Phase 2: Core Genesis

### Get Updated Genesis File

After the ZetaChain coordinator has merged the PRs and updated the genesis file:

- Switch back to the `main` branch
- Pull the latest changes to get the updated genesis.json file

```bash
git switch main
git pull
```

#### Start The Node

```bash
./scripts/start-zetacore.sh
```

**Optional** The `start-zetacore.sh` script will automatically update the config
file (`~/.zetacored/config/config.toml`) with a persistent peer. If you did not
use the `start-zetacored.sh` script you need to update the config file manually
with the peer information.

#### Wait for Genesis to Complete

**Wait until ZetaChain coordinator confirms that genesis is completed.** Then
You can terminate the `zetacored` process that was manually started in the
previous step. You'll want to resume zetacored using a more robust process
management system. See the final section below for more information.

```bash
pkill zetacored
```

If you are an Observer Signer Validator you must leave zetacored running and
move onto the next step.

## Phase 3: TSS Keygen (`zetaclientd`)

This phase applies to **Observer/Signer Validators only**. Most operators are
"core validators" and can skip this step. If you aren't sure what you are, you
are most likely a core validator.

### Configure RPC Connectivity

Observer Signers need an RPC endpoint for each connected chain. You can follow
the standard instructions to configure a node for most chains but the BTC
requires special instructions just for ZetaChain. The links below will take you
to a node setup guide for each chain.

- [Ethereum RPC Node Setup](https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/)
- [BSC RPC Node Setup](https://docs.bnbchain.org/docs/validator/fullnode/)
- [Polygon RPC Node Setup](https://wiki.polygon.technology/docs/category/run-a-full-node)
- [BTC RPC Node Setup](btc-rpc.md)

Edit the `zeta-client.toml` file located in the `.zetacored/config` directory
and add the RPC endpoints to the `Endpoint = ` section of each chain.

### Set Public IP

If your node has a public IP and private IP (such as AWS EC2 instance), then you
need to set the `MYIP` environment variable to your public IP otherwise the p2p
connection will not work.

```bash
export MYIP=3.141.21.139
```

### Start `zetaclient`

- `KeygenBlock` will be provided by the ZetaChain coordinator.

```bash
SEEDIP=3.218.170.198
KEYGENBLOCK=<Keygen Block Provided By ZetaChain coordinator>
./scripts/start-zetaclient.sh -k $KEYGENBLOCK-s $SEEDIP
```

**Wait until ZetaChain coordinator confirms that TSS keygen is completed**. Then
terminate the processes `zetacored` and `zetaclientd`.

```bash
pkill zetaclientd
pkill zetacored
```

## Process Management for `zetacored` and `zetaclientd`

These instructions are for the initial setup and genesis of the network. Running
a validator 24/7 requires a more robust setup that will change depending on the
environment you are running the validator in. At a minimum we reccomend you:

- [ ] Run each process as a systemd service or containerized service
- [ ] Do NOT run these services as root. Create a new restricted ZetaChain user
- [ ] Create Sentry nodes to protect your validator
- [ ] Setup ngnix to forward p2p traffic from Sentry node to zetaclientd -- TODO
      add documentation for this
- [ ] Make sure you setup resource monitoring (CPU, RAM, etc), uptime
      monitoring, log ingestion, etc to minimize the risk of downtime or
      slashing
- [ ] Install adequate security measures such as, Endpoint protection,
      Anti-Virus, system level logging, WAF, etc

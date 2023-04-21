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
```
wget https://zetachain-external-files.s3.amazonaws.com/binaries/athens3/latest/zetacored-ubuntu
wget https://zetachain-external-files.s3.amazonaws.com/binaries/athens3/latest/zetaclientd-ubuntu
mv zetaclientd-ubuntu /usr/bin/zetacored && chmod +x /usr/bin/zetacored
mv zetaclientd-ubuntu /usr/bin/zetaclientd && chmod +x /usr/bin/zetaclientd
# You may need to set additional permissions depending on your node configuration
```

#### Clone the network github repository
```bash
git clone https://github.com/zeta-chain/network-athens3.git && cd network-athens3
```

#### Run The Node Setup Script

Give execute permissions to the scripts and run the node setup script

```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh
```

After the `node-setup.sh` script generates the keys and necessary files, create
a branch, commit, and raise a PR to submit the files to zetachain coordinator:

  - Use `Branch-Name-<YourName>` as the branch name for the new branch. 
  - The pr should contain only `os_info.json` and `gentx-XX.json`. Use `git status` to check 
  - If there is a file `network_files/config/genesis.json` do not commit it.
  This file can be deleted ,it is not required.The genesis being used will
  beprovided by the coordinator.

NOTE : A backup up is created for the existing zetacored folder under
`~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .
  
## Phase 2: Core Genesis

#### Start The Node 

**Wait for final genesis to be provided by the ZetaChain Coordinator before
starting the following process** Additional parameters will be provided by the
ZetaChain Coordinator. 

Edit config file (~/.zetacored/config/config.toml) to
  - Add persistent peers - Edit config.toml to check for SEED (make it empty if
  it has a value)

```bash
./scripts/start-zetacore.sh
```


**Wait until ZetaChain coordinator confirms that genesis is completed**. 
You can terminate the `zetacored` process that was manually started in the
previous step. You'll want to resume zetacored using a more robust process
management system. See the final section below for more information.

```bash
pkill zetacored
```

## Phase 3: TSS Keygen (zetaclientd) 

This phase applies to **Observer/Signer Validators only**. Most operators are `core
validators` and can skip this step. If you aren't sure what you are, you are
most likely a core validator.

Start Zetaclient
  - `KeygenBlock` and `SEEDIP` are provided by the the coordinator.

```bash
./scripts/start-zetaclient.sh -k <KeygenBlock> -s <SEEDIP>
```

**Wait until zetachain coordinator confirms that TSS keygen is completed**. 
Then terminate the processes `zetacored` and `zetaclientd`.

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
- [ ] Make sure you setup resource monitoring (CPU, RAM, etc), uptime
monitoring, log ingestion, etc to minimize the risk of downtime or slashing 
- [ ] Install adequate security measures such as, Endpoint protection, Anti-Virus,
system level logging, WAF, etc  


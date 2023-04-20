### Node Setup
Here we assume a typical Ubuntu 22.04 LTS x86_64 setup. If you are using a different OS you may need to make some adjustments.
For more information about the compute node requirement see [here](hosting.md)

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
mv zetaclientd-ubuntu /usr/bin/zetaclientd && chmod +x zetaclientd
# You may need to set additional permissions depending on your node configuration
```

#### Clone the network github repository
```bash
git clone https://github.com/zeta-chain/network-athens3.git && cd network-athens3
```

Check out a specific branch. Branch name will be provided by the coordinator
```bash
git checkout <Branch-Name>
```

#### Run The Node Setup Script

Give execute permissions to the scripts and run the node setup script

```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh
```

After the `node-setup.sh` script generates the keys and necessary
files, create a branch, commit, and raise a PR to submit the files
to zetachain coordinator:

  - Use `Branch-Name-<YourName>` as the branch name for the new branch.
  - The pr should contain only `os_info.json` and `gentx-XX.json`. Use `git status` to check
  - If there is a file `network_files/config/genesis.json` do not commit it.This file can be deleted ,it is not required.The genesis being used will be provided by the coordinator.

NOTE : A backup us created for the existing zetacored folder under `~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .
  

#### Start The Node 

**Wait for final genesis to be provided by the ZetaChain Coordinator before starting the following process**
Additional parameters will be provided by the ZetaChain Coordinator. 

Edit config file (~/.zetacored/config/config.toml) to
  - Add persistent peers
  - Edit config.toml to check for SEED (make it empty if it has a value)

```bash
./scripts/start-zetacore.sh
```

Start Zetaclient
  - `KeygenBlock` and `SEEDIP` are provided by the the coordinator.

```bash
./scripts/start-zetaclient.sh -k <KeygenBlock> -s <SEEDIP>
```

**Wait until zetachain coordinator confirms that genesis and TSS keygen is completed**. 
Then terminate the processes `zetacored` and `zetaclientd`.

```bash
pkill zetaclientd
pkill zetacored
```


## Setup Process Management for `zetacored` and `zetaclientd`
These instructions are for the initial setup and genesis of the network. 
Running a validator 24/7 requires a more robust setup that will change depending on the environment you are running the validator in.
At a minimum we reccomend you: 
- [ ] Run each process as a systemd service
- [ ] Do NOT run these services as root. Create a new restricted ZetaChain user
- [ ] Create Sentry nodes to protect your validator 
- [ ] Make sure you setup resource monitoring (CPU, RAM, etc), uptime monitoring, log ingestion, etc to minimize the risk of downtime or slashing 
- [ ] Install adequate security measures such as, Endpoint protection, Anti-Virus, system level logging, WAF, etc  

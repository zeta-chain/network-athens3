### Node Setup
Here we assume a typical Ubuntu 22.04 LTS x86_64 setup. If you are using a different OS you may need to make some adjustments.
For more information about the compute node requirement see [here](hosting.md)

Make sure `jq`, `git`, `curl`, and `make` are installed. 

```bash
sudo apt update
sudo apt install -y jq curl git 
jq --version
```

Now clone the network github repository
```bash
git clone https://github.com/zeta-chain/network-athens3.git && cd network-athens3
```

Check out a specific branch. Branch name will be provided by the coordinator
```bash
git checkout <Branch-Name>
```

Give execute permissions to the scripts and run the node setup script
```bash
chmod +x ./scripts/*.sh
```

```bash
./scripts/node-setup.sh
```

After the `node-setup.sh` script generates the keys and necessary
files, create a branch , Commit , and Raise a PR to submit the files
to zetachain coordinator:

  - Use `Branch-Name-<YourName>` as the branch name for the new branch.
  - The pr should contain only `os_info.json` and `gentx-XX.json`. Use `git status` to check
  - If there is a file `network_files/config/genesis.json` do not commit it.This file can be deleted ,it is not required.The genesis being used will be provided by the coordinator.

NOTE : A backup us created for the existing zetacored folder under `~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .
    

  

### Start Node Step
<div style="border: 1px solid black; padding: 10px;">
Wait for final genesis to be provided by the Coordinator of the ceremony
</div>

Edit config file (~/.zetacored/config/config.toml) to
  - Add persistant peers
  - Edit config to check for SEED (make it empty if it has a value)
  - Start Node

```bash
./scripts/start-zetacore.sh
```

Start Zetaclient
  - `KeygenBlock` and `SEEDIP` are distributed by the the coordinator.

```bash
./scripts/start-zetaclient.sh -k <KeygenBlock> -s <SEEDIP>
```

## Orchestrator / Coordinator
<div style="border: 1px solid black; padding: 10px;">
These should only be run by the coordinator, once all PRs from the node setup steps are raised
</div>

### Collector
- Merge all PRS
- `git pull` the merged branch so that you have all the files in the gentx folder

```bash
./scripts/genesis_collector.sh
```

- This would put a genesis.json into the `genesis_files/config/` folder
    - Commit and push the file to the Repo
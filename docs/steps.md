### Node Setup

```bash
sudo apt update
sudo apt install -y jq
jq --version
```

```bash
git clone https://github.com/zeta-chain/network-athens3.git && cd network-athens3
```

- Branch name will be provided by the coordinator
```bash
git checkout <Branch-Name>
```

```bash
chmod +x ./scripts/*.sh
```

```bash
./scripts/node-setup.sh
```

- Create a branch , Commit , and Raise a PR
  - Use `Branch-Name-<YourName>` as the branch name for the new branch.
  - The pr should contain only `os_info.json` and `gentx-XX.json`. Use `git status` to check
  - If there is a file `network_files/config/genesis.json` do not commit it.This file can be deleted ,it is not required.The genesis being used will be provided by the coordinator.

- NOTE : A backup us created for the existing zetacored folder under `~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .
    

  

### Start Node Step

- Wait for final genesis to be provided . By the Coordinator of the ceremony

Edit config file (~/.zetacored/config/config.toml) to
  - Add persistant peers
  - Edit config to check for SEED (make it empty if it has a value)
  - Start Node

```bash
./scripts/start-zetacore.sh
```

- Start Zetaclient
    - `KeygenBlock` and `SEEDIP` can be decided offchain

```bash
./scripts/start-zetaclient.sh -k <KeygenBlock> -s <SEEDIP>
```

## Orchestrator / Coordinator

These should only be run by the coordinator , once all prs from the node setup steps are raised
### Collector
- Merge all PRS
- `git pull` the merged branch so that you have all the files in the gentx folder

```bash
./scripts/genesis_collector.sh
```

- This would put a genesis.json into the `genesis_files/config/` folder
    - Commit and push the file to the Repo
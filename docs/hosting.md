# Hosting a Node (Simplified)

## Technical Requirements

### Node Specifications

These are some recommended specs to run the different type of ZetaChain nodes.

| Validator | 4 CPUs | 32 GB Memory | 50 GB Root disk
300 GB Data disk |
| --- | --- | --- | --- |
| API Node | 4 CPUs | 32 GB Memory | 50 GB Root disk
300 GB Data disk |
| Full Node / Statesync Node | 4 CPUs | 32 GB Memory | 50 GB Root disk
300 GB Data disk |
| Archive Node | 4 CPUs | 32 GB Memory | 50 GB Root disk
500 GB Data disk* |

*Archive nodes store the entire blockchain. As the blockchain grows, more disk space is needed.

### Operating System

ZetaChain nodes have been developed and tested on x86_64 architecture. Our binary files have been compiled with Ubuntu 22.04 LTS x86_64. This guide assumes you are using Ubuntu 22.04 LTS x86_64. If you are using a different OS you may need to make some adjustments.   

## Getting Started

### Set Limits on Open Files and Number of Processes

To better manage the resources of your nodes, we recommend setting some limits on the maximum number of open file descriptors (nofile) and maximum number of processes (nproc).

Edit `/etc/security/limits.conf` to include or modify the following parameters:

```jsx
*       soft    nproc   262144
*       hard    nproc   262144
*       soft    nofile  262144
*       hard    nofile  262144
```

Edit `/etc/sysctl.conf` to include the following:

```jsx
fs.file-max=262144
```

### Using Cosmovisor

This is not a requirement, but Cosmovisor can be helpful in managing the upgrade process. Please refer to their documentation to learn how to install and configure Cosmovisor to be used with ZetaChain.

[Cosmovisor | Cosmos SDK](https://docs.cosmos.network/main/tooling/cosmovisor)

### Create ZetaChain Directory Structure

This is needed to store ZetaChain binary and configuration files.

```bash
sudo su zetachain
mkdir -p ~/.zetacored/bin
mkdir ~/.zetacored/config
mkdir ~/.tss
```

### Download and Install ZetaChain Binary Files

ZetaChain core binary file can be downloaded from the following URL.

```jsx
https://zetachain-external-files.s3.amazonaws.com/binaries/<blockchain_name>/zetacored
```

- `blockchain_name` is current blockchain name (example for Testnet is currently `athens2`)

Copy this binary to a location of your choosing. For the rest of this guide we’ll assume you used your home directory  `~/.zetacored/bin/zetacore`

To make it easier to run from the command line you can create a symbolic link from `/usr/local/bin` pointing to it. 

## General Settings

### Install ZetaChain Configuration Files

ZetaChain configuration files can be downloaded from the following URLs.

```jsx
https://zetachain-external-files.s3.amazonaws.com/config/<blockchain_name>/app.toml
https://zetachain-external-files.s3.amazonaws.com/config/<blockchain_name>/client.toml
https://zetachain-external-files.s3.amazonaws.com/config/<blockchain_name>/config.toml
https://zetachain-external-files.s3.amazonaws.com/genesis/<blockchain_name>/genesis.json
```

- `blockchain_name` is current blockchain name (example for Testnet is currently `athens2`)

Copy the files to your zetacored config directory:

```bash
~/.zetacored/config/app.toml
~/.zetacored/config/client.toml
~/.zetacored/config/config.toml
~/.zetacored/config/genesis.json
```

## CLI

ZetaChain Core is built with the Cosmos SDK. There is an `zetacored --help` flag that can be used with any subcommand to learn its use and syntax

### Start ZetaChain Core

The following example shows how to connect a ZetaChain node to Testnet (Athens2).

Edit the following variables in `~/.zetacored/config/config.toml`

```jsx
moniker = “my_node_name” 
seeds = "a417c375685afb97b7210d4c101c835521572731@35.170.251.63:26656"
pprof_laddr = "localhost:6060”
laddr = "tcp://0.0.0.0:26657”
proxy_app = "tcp://0.0.0.0:26658”
```

To use our state sync nodes to sync up with the ZetaChain blockchain, run the following command on your local machine:

```bash
curl -s http://44.212.168.142:26657/block | jq -r '.result.block.header.height + "\n" + .result.block_id.hash'

# Example Output
393427
EA446B13ADF6A17CB63723D126BCF88BB3EAEA643E2633896B9DCEAEF9F7C9F8w
```

Use the return values to edit the following variables in `config.toml`:

```bash
[statesync]
# State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine
# snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in
# the network to take and serve state machine snapshots. State sync is not attempted if the node
# has any local state (LastBlockHeight > 0). The node will have a truncated block history,
# starting from the height of the snapshot.
enable = true

# RPC servers (comma-separated) for light client verification of the synced state machine and
# retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding
# header hash obtained from a trusted source, and a period during which validators can be trusted.
#
# For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2
# weeks) during which they can be financially punished (slashed) for misbehavior.
rpc_servers = "35.170.251.63:26657,44.212.168.142:26657"
trust_height = 393427 # Use the values from the previous step
trust_hash = "EA446B13ADF6A17CB63723D126BCF88BB3EAEA643E2633896B9DCEAEF9F7C9F8"
```

Start the ZetaChain node:

```bash
zetacored start 
```

You should see zetacored start and begin looking for the latest snapshot. You’ll see `ADD_MESSAGE_HERE` in the logs when it is syncing. This typically takes 60-90 minutes to complete. 

### Run zetacored as a service

After your initial sync we recommended running zetacored as a systemd service but we do not provide instructions to do this or offer support for it. If interested in this you can learn more about systemd here.  

## Monitoring

In a production environment we recommend monitoring the node resources (CPU load, Memory Usage, Disk usage and Disk IO) for any performance degradation.

Prometheus can optionally be enabled to serve metrics which can be consumed by Prometheus collector(s). Telemetry include Prometheus metrics can be enabled in the app.toml file. See the [CosmosSDK Telemetry Documentation](https://docs.cosmos.network/v0.45/core/telemetry.html) for more information.
## Node Technical Requirements

### Node Specifications

These are some recommended specs for a ZetaChain node.

| Node Type       | CPU    | Memory       | Data Disk         |
| :-------------- | :----- | :----------- | :---------------- |
| Observer Signer | 8 CPUs | 32 GB Memory | 300+ GB Data Disk |
| Core Validator  | 4 CPUs | 16 GB Memory | 300+ GB Data Disk |


### Operating System

ZetaChain nodes have been developed and tested on x86_64 architecture. Our
binary files have been compiled with Ubuntu 22.04 LTS x86_64. This guide assumes
you are using Ubuntu 22.04 LTS x86_64. If you are using a different OS you may
need to make some adjustments.

## Getting Started

### Set Limits on Open Files and Number of Processes

To better manage the resources of your nodes, we recommend setting some limits
on the maximum number of open file descriptors (nofile) and the maximum number of
processes (nproc).

Edit `/etc/security/limits.conf` to include or modify the following parameters:

```bash    
*       soft    nproc   262144 
*       hard    nproc   262144
*       soft    nofile  262144 
*       hard    nofile  262144
```

Edit `/etc/sysctl.conf` to include the following:

```bash
fs.file-max=262144 
```

## Monitoring

In a production environment we recommend monitoring the node resources (CPU
load, Memory Usage, Disk usage and Disk IO) for any performance degradation.

Prometheus can optionally be enabled to serve metrics that can be consumed by
Prometheus collector(s). Telemetry include Prometheus metrics can be enabled in
the app.toml file. See the [CosmosSDK Telemetry Documentation](https://docs.cosmos.network/v0.46/core/telemetry.html) for more information.


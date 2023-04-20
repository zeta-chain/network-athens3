## Node Technical Requirements

### Node Specifications

These are some recommended specs to a ZetaChain node. 

CPU | Memory | Root Disk | Data Disk |
:--- | :--- | :--- | :--- |
4 CPUs | 32 GB Memory | 50 GB Root disk | 250 GB Data Disk ( 500 GB+ for Archive)  |

*Archive nodes store the entire blockchain. As the blockchain grows, more disk
space is needed.

### Operating System

ZetaChain nodes have been developed and tested on x86_64 architecture. Our
binary files have been compiled with Ubuntu 22.04 LTS x86_64. This guide assumes
you are using Ubuntu 22.04 LTS x86_64. If you are using a different OS you may
need to make some adjustments.   

## Getting Started

### Set Limits on Open Files and Number of Processes

To better manage the resources of your nodes, we recommend setting some limits
on the maximum number of open file descriptors (nofile) and maximum number of
processes (nproc).

Edit `/etc/security/limits.conf` to include or modify the following parameters:

```jsx *       soft    nproc   262144 *       hard    nproc   262144 *
soft    nofile  262144 *       hard    nofile  262144 ```

Edit `/etc/sysctl.conf` to include the following:

```jsx fs.file-max=262144 ```


## Monitoring

In a production environment we recommend monitoring the node resources (CPU
load, Memory Usage, Disk usage and Disk IO) for any performance degradation.

Prometheus can optionally be enabled to serve metrics which can be consumed by
Prometheus collector(s). Telemetry include Prometheus metrics can be enabled in
the app.toml file. See the [CosmosSDK Telemetry
Documentation](https://docs.cosmos.network/v0.45/core/telemetry.html) for more
information.

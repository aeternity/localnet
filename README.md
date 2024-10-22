# Aeternity Localnet

Docker compose based configuration to easily run locally deployed dev/test network.
Latest config files support node `v6.*` For older node versions use the `v1.*` tags of this repository.

This repository provide two setups described below:

* Single node configuration in devmode (default) -- good for smart contracts testing and node API features
* 3 Node configuration - good to test p2p, consensus etc. features

Single node configuration uses the [devmode plugin](https://github.com/aeternity/aeplugin_dev_mode) in default configuration.

The 3 node configuration uses the `mean15-generic` miner (fastest generic miner).
As the beneficiary key-pair is publicly available, this setup should *not* be connected to public networks.

All local network nodes are configured with the same beneficiary account (for more details on beneficiary see [configuration documentation](https://github.com/aeternity/aeternity/blob/master/docs/configuration.md#beneficiary-account)):
- public key: ak_twR4h7dEcUtc2iSEDv8kB7UFJJDGiEDQCXr85C3fYF8FdVdyo
- private key secret: `secret`
- key-pair binaries can be found in `/node/keys/beneficiary` directory of this repository

### Addresses

The configuration uses a proxy server to allow CORS and URL routing.

All APIs (external, internal and state channels websocket) are exposed to the docker host, the URL pattern is as follows:

- external/internal API - http://$DOCKER_HOST_ADDRESS:8080/nodeX
- channels API - ws://$DOCKER_HOST_ADDRESS:8080/nodeX/channel

For example if one wants to use `node1` API on local docker host the address is: http://localhost:8080/node1/v2/status

Also the node1 is always available without URL path suffix, for example:

http://localhost:8080/v2/status

Also node1 have the standard port bindings as well:

- port 3013 - External API
- port 3113 - Internal API
- port 3014 - State Channels API
- port 3313 - Dev Mode plugin

### Single Node Configuraiton (default)

To use a Single Node Configuration start the containers with the docker compose command. Example:

```bash
docker compose up -d
```

Check if the node is running:

```bash
curl http://localhost:8080/v2/status
```

To destroy the network:

```bash
docker compose down
```

To cleanup the associated docker volumes, `-v` option could be used:

```bash
docker compose down -v
```

More details can be found in [`docker-compose` documentation](https://docs.docker.com/compose/reference/).

### 3 Node configuration

To start the 3 node configuration use the additional docker compose config:

```bash
docker compose -f docker-compose.multi.yml up -d
```

Node names:
- `node1`
- `node2`
- `node3`

For example to access `node2` API (status), assuming docker host address is `localhost`:

```bash
curl http://localhost:8080/node2/v2/status
```

### Full infrastructure configuration

This configuration includes a node+middleware, explorer, base wallet, faucet and compiler.
To boot it run:

```bash
docker compose -f docker-compose.full.yml up -d
```

List of all services and their URLs can be found at: http://localhost:8000

### Hyperchains configuration

This configuration runs the full infrastructure (see above) as *parent chain* and a copy of it as *child chain* + Hyperchains UI.
To boot it run:

```bash
docker compose -f docker-compose.full.yml -f docker-compose.hyperchain.yml up -d
```

List of all *parent chain* services and their URLs can be found at: http://localhost:8000
List of all *child chain* services and their URLs can be found at: http://localhost:8080

### Image Version

3 node configuration uses the `aeternity/aeternity:latest` image by default, it will be pulled from [docker hub](https://hub.docker.com/r/aeternity/aeternity/) if it's not found locally.

To change what node version is used set `IMAGE_TAG` environment variable, e.g.:

```bash
IMAGE_TAG=v4.0.0 docker compose up -d
```

This configuration is known to work with node versions >= 5.0.0

The devmode (single node) configuration uses the `aeternity/aeternity:latest-bundle` by default which included the [devmode plugin](https://github.com/aeternity/aeplugin_dev_mode)

The image can be changed (i.e. to specific version) by setting `IMAGE_TAG` environment variable.

### Mining Rate

By default the 3 nodes localnet has set default mine rate of 1 block per 15 seconds.
It can be changed by setting `AETERNITY_MINE_RATE` environment variable.
The variable is in milliseconds, so to set 1 block per 10 seconds use:

```bash
AETERNITY_MINE_RATE=10000 docker compose -f docker-compose.multi.yml up
```

### Accounts

This configuration includes 3 genesis pre-funded accounts:

| Ammount                           | Public Address    |
| -----------                       | -----------       |
| 1000000000000000000000            | ak_AnYx7qbt5PZeNfa8kvAxA9WS3mGpSGAsshGbG6bkDLVtCxmMT       |
| 2000000000000000000000            | ak_22vGvAfLipm8vK6ExtDxGEfbDXSeSEt9Ur87xyL2F11gb8ZRKg      |
| 2000000000000000000000            | ak_XwTENL7b2UNqrbqqput7GrPPBxbXXWx7kiwxCz2C4oMAp1H8u       |

Wallets for the accounts can be found in the [aepp template repository](https://github.com/aeternity/aepp-template#wallets).

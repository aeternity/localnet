# æternity dev single node docker compose

Docker compose for running a single node æternity client.

It runs one node using the `mean15-generic` miner (fastest generic miner) and allows CORS and URL routing.

The beneficiary key-pair is publicly available, so this setup is only for development purpose and  should *not* be connected to public networks.
For more details on beneficiary see [configuration documentation](https://github.com/aeternity/aeternity/blob/master/docs/configuration.md#beneficiary-account)):

- public key: ak_twR4h7dEcUtc2iSEDv8kB7UFJJDGiEDQCXr85C3fYF8FdVdyo
- private key secret: `secret`
- key-pair binaries can be found in `/node/keys/beneficiary` directory of this repository

The node expose æternity node default ports (3013, 3014).

For example to access node peer public key, assuming docker host address is `localhost`:

```bash
curl http://localhost:3013/v2/peers/pubkey
```

To start the network:

```bash
docker-compose up -d
```

To destroy the network:

```bash
docker-compose down
```

To cleanup the associated docker volumes, `-v` option could be used:

```bash
docker-compose down -v
```

More details can be found in [`docker-compose` documentation](https://docs.docker.com/compose/reference/).

### Image Version

Docker compose uses the `aeternity/aeternity:latest` image by default, it will be pulled from [docker hub](https://hub.docker.com/r/aeternity/aeternity/) if it's not found locally.

To change what node version is used set `IMAGE_TAG` environment variable, e.g.:

```bash
IMAGE_TAG=v4.0.0 docker-compose up -d
```

### Mining Rate

By default the localnet has set default mine rate of 1 block per 15 seconds.
It can be changed by setting `AETERNITY_MINE_RATE` environment variable.
The variable is in milliseconds, so to set 1 block per 10 seconds use:

```bash
AETERNITY_MINE_RATE=10000 docker-compose up
```

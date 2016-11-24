[![build status](https://gitlab.timmertech.nl/docker/alpine-postgresql/badges/master/build.svg)](https://gitlab.timmertech.nl/docker/alpine-postgresql/commits/master)

# docker/alpine-postgresql:9.6.0

# Image details:
 - Alpine Linux: 3.4
 - S6-Overlay: 1.18.1.5
 - Postgresql: 9.6.0-r1

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Locations](#locations)
  - [Configuration Options](#configuration-options)
  - [Trusting local connections](#trusting-local-connections)

 
# Introduction
  
# Getting Started

```bash
docker pull registry.timmertech.nl/docker/alpine-postgresql
```

# Locations

Default Locations:

| Type | Location |
|------|----------|
| Data Directory | /var/lib/postgresql |
| Log Directory | /var/log/postgresql |

# Configuration Options

| Option | Description |
|--------|-------------|
| PG_UID `UID` | Map ownership to UID |
| PG_GID `GID` | Map ownership to GID |
| PG_TRUST_LOCALNET `true || false` | Enabling, will trust connections from the local network (default: false) [Details](#trusting-local-connections) |

## Trusting local connections

By default connections to the PostgreSQL server need to authenticated using a password. If desired you can trust connections from the local network using the `PG_TRUST_LOCALNET` variable.

```bash
docker run --name postgresql -itd --restart always \
  --env 'PG_TRUST_LOCALNET=true' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

> **Note**
>
> The local network here is network to which the container is attached. This has different meanings depending on the `--net` parameter specified while starting the container. In the default configuration, this parameter would trust connections from other containers on the `docker0` bridge.
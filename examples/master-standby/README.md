# Master with Standby

## Prerequisites

Create docker network, see [examples on how to do this](..)

## Start Master

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-master
```

## Start Standby-1

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-standby-1
```

## Start Standby-2

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-standby-2
```

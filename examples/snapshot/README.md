# Create snapshot from Master

## Prerequisites

Create docker network, see [examples on how to do this](..)

## Start Master

Start [Master](../master/) node first.

## Create Snapshot

With `bash`

```bash
cd snapshot
./create-snapshot.sh
```

With `docker-compose`

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up
```

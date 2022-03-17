# Create backup from Master

## Prerequisites

Create docker network, see [examples on how to do this](..)

## Start Master

Start [Master](../master) node first.

## Create Backup

With `bash`

```bash
cd backup
./create-backup.sh
```

With `docker-compose`

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up
```

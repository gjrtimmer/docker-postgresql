# Examples

## Prerequisites

In order to run the examples a custom docker network has be used so that its easy for the containers to find each other.

### Create docker network

Create a custom docker network for the postgresql playground; adjust the IP ranges only when they are already in use on your machine.

In this custom network each container is given a static IP with the exception of the backup script. This container will use a automatically assigned container.

```bash
docker network create --subnet=172.50.0.0/16 --ip-range=172.50.50.1/24 --gateway=172.50.0.1 psql-playground
```

### View docker network list

```bash
docker network ls
```

### View details of docker network

```bash
docker network inspect psql-playground
```

### Remove docker network

When you are done playing you can remove the docker network with the following command.

```bash
docker network rm psql-playground
```

### docker network IP assignment

| IP          | Example  |
| ----------- | -------- |
| 172.50.0.5  | Single   |
| 172.50.0.10 | Master   |
| 172.50.0.15 | Backup   |
| 172.50.0.20 | Snapshot |

## Single

**Important: If you want to be able to run a backup of your single instance please use (#Master-with-Backup)[Master with Backup] configuration; the single node has the journal set to minimal; and has no wal senders required for the backup process.**

## Master


## Create backup from Master

## Create snapshot from Master

Start [Master](#master) node first.

With `bash`

```bash
cd snapshot
./create-snapshot.sh
```

With `docker-compose`

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up
```

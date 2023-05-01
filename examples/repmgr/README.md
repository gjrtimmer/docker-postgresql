# Master with Standby

- [Prerequisites](#prerequisites)
- [Startup](#startup)
- [psql-1](#psql-1)
  - [Start psql-1](#start-psql-1)
  - [Shell psql-1](#shell-psql-1)
- [psql-2](#psql-2)
  - [Start psql-2](#start-psql-2)
  - [Shell psql-2](#shell-psql-2)
- [psql-3](#psql-3)
  - [Start psql-3](#start-psql-3)
  - [Shell psql-3](#shell-psql-3)
- [psql-4](#psql-4)
  - [Start psql-4](#start-psql-4)
  - [Shell psql-4](#shell-psql-4)

## Prerequisites

Create docker network, see [examples on how to do this](..)

## Startup

Please start the containers consecutively, and give each container time to startup and register itself with the cluster manager.

## psql-1

### Start psql-1

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-1
```

### Shell psql-1

```bash
docker exec -it psql-1 bash
```

## psql-2

### Start psql-2

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-2
```

### Shell psql-2

```bash
docker exec -it psql-2 bash
```

## psql-3

### Start psql-3

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-3
```

### Shell psql-3

```bash
docker exec -it psql-3 bash
```

## psql-4

### Start psql-4

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up psql-4
```

### Shell psql-4

```bash
docker exec -it psql-4 bash
```

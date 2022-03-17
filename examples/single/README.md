# Start Single Server

## Prerequisites

Create docker network, see [examples on how to do this](..)

## Start Server

With `docker-compose`

```bash
PUID=$(id -u) PGID=$(id -g) docker-compose up
```

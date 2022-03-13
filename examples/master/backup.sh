#!/usr/bin/env bash

# Create Backup of Master
docker run \
  --rm \
  --name psql-backup \
  --network=bridge \
  --env REPLICATION_USER=replicate \
  --env REPLICATION_PASS=replicate \
  --env REPLICATION_HOST=psql-master \
  --env REPLICATION_PORT=5432 \
  --env REPLICATION_MODE=backup \
  --volume "${PWD}/backup:/var/lib/postgresql" \
  gjrtimmer/postgresql:latest

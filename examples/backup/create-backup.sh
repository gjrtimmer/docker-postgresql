#!/usr/bin/env bash

# Create Backup of master
docker run \
  --rm \
  --name psql-backup \
  --network psql-playground \
  --link psql-master:master \
  --env REPLICATION_USER=replicator \
  --env REPLICATION_PASS=replicator \
  --env REPLICATION_HOST=master \
  --env REPLICATION_PORT=5432 \
  --env REPLICATION_MODE=backup \
  --volume "${PWD}/backup/postgresql.$(date +%Y%m%d-%H%M):/config" \
  gjrtimmer/postgresql:latest

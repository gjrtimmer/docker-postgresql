#!/usr/bin/env bash

# Create snapshot of master
docker run \
  --rm \
  --name psql-snapshot \
  --network psql-playground \
  --link psql-master:master \
  --env REPLICATION_USER=replicator \
  --env REPLICATION_PASS=replicator \
  --env REPLICATION_HOST=master \
  --env REPLICATION_PORT=5432 \
  --env REPLICATION_MODE=snapshot \
  --volume "${PWD}/snapshot:/config" \
  gjrtimmer/postgresql:latest

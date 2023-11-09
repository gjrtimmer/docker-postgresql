#!/usr/bin/env bash

if ! docker network ls --format '{{.Name}}' | grep -q "synohub" -; then
  docker network create --subnet=172.50.0.0/16 --ip-range=172.50.50.1/24 --gateway=172.50.0.1 psql-playground
fi

PUID=$(id -u) PGID=$(id -g) docker-compose up -d

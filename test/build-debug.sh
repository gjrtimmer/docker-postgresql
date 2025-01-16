#!/usr/bin/env bash
# shellcheck shell=bash

IMAGE=psql-debug

docker build --progress=plain --target builder -f docker/Dockerfile.base -t $IMAGE .
docker run --rm --entrypoint=bash -it $IMAGE

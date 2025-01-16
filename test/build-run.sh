#!/usr/bin/env bash
# shellcheck shell=bash

IMAGE=psql-build

docker build --progress=plain -t $IMAGE .
docker run --rm -it $IMAGE

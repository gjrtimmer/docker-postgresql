#!/usr/bin/env bash
# shellcheck shell=bash

IMAGE=harbor.local/gitlab/docker/postgresql:$(git rev-parse --short=8 HEAD)

docker pull $IMAGE
docker run --rm -it $IMAGE

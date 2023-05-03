#!/usr/bin/env bash
# shellcheck shell=bash
# Load Environment
for VAR in /var/run/s6/container_environment/*; do
    export "$(basename "${VAR}")"="$(cat "${VAR}")"
done

# EOF

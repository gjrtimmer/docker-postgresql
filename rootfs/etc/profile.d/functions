#!/usr/bin/with-contenv bash
set -e

source /etc/postgresql/env-defaults

## Execute command as PG_USER
exec_as_postgres() {
  sudo -HEu postgres "$@"
}

# EOF
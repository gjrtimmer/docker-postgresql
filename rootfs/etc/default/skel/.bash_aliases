# shellcheck shell=bash
# Aliases
alias repmgr='s6-setuidgid abc repmgr -f "${REPMGR_CONF}"'
alias rcs='repmgr cluster show'
alias rstat='repmgr cluster show'
alias psql-start='sudo s6-svc -u /run/service/svc-postgres'
alias psql-stop='sudo s6-svc -d /run/service/svc-postgres'
alias psql-restart='sudo s6-svc -r /run/service/svc-postgres'
alias psql-reload='s6-setuidgid abc pg_ctl reload -D ${PG_DATA_DIR}'

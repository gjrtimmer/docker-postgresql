#!/usr/bin/with-contenv bash
# Functions taken from sameersbn/docker-postgresql
set -e

source /etc/postgresql/env-defaults

## Execute command as PG_USER
exec_as_postgres() {
  sudo -HEu postgres "$@"
}

set_postgresql_param() {
	local key=${1}
	local value=${2}
	local verbosity=${3:-verbose}

	if [[ -n ${value} ]]; then
		local current=$(s6-setuidgid ${PG_USER} sed -n -e "s/^\(${key} = '\)\([^ ']*\)\(.*\)$/\2/p" ${PG_CONF})
		
		if [[ "${current}" != "${value}" ]]; then
			
			if [[ ${verbosity} == verbose ]]; then
				echo "  Setting postgresql.conf parameter: ${key} = '${value}'"
			fi
	
			value="$(echo "${value}" | sed 's|[&]|\\&|g')"
			s6-setuidgid ${PG_USER} sed -i "s|^[#]*[ ]*${key} = .*|${key} = '${value}'|" ${PG_CONF}
		fi
	fi
}

set_recovery_param() {
	local key=${1}
	local value=${2}
	local hide=${3}
  
	if [[ -n ${value} ]]; then
		local current=$(s6-setuidgid ${PG_USER} sed -n -e "s/^\(.*\)\(${key}=\)\([^ ']*\)\(.*\)$/\3/p" ${PG_RECOVERY_CONF})

		if [[ "${current}" != "${value}" ]]; then
			case ${hide} in
				true)  	echo "  Setting primary_conninfo parameter: ${key}" ;;
				*) 		echo "  Setting primary_conninfo parameter: ${key} = '${value}'" ;;
			esac

			s6-setuidgid ${PG_USER} sed -i "s|${key}=[^ ']*|${key}=${value}|" ${PG_RECOVERY_CONF}
		fi
	fi
}

set_hba_param() {
	local value=${1}

	if ! grep -q "$(sed "s| | \\\+|g" <<< ${value})" ${PG_HBA_CONF}; then
		echo "${value}" >> ${PG_HBA_CONF}
	fi
}

# EOF
# Environment Variables

Complete overview of all supported environment variables. The environment variables are categorized in order to make the overview easier to read.

> **Boolean Values**
>
> When a variable is listed in the overview with a default value like `off (BOOL)` it means its a boolean value
> for turning on or off a certain feature. All accepted values are case-insensitive.
>
> The following values are accepted:\
> ON: `1`, `true`, `TRUE` `enable`, `ENABLE`, `enabled`, `ENABLED`, `on`, `ON`\
> OFF: `0`, `false`, `FALSE`, `disable`, `DISABLE`, `disabled`, `DISABLED`, `off`, `OFF`

## Table of Contents

- [Environment Variables](#environment-variables)
  - [Table of Contents](#table-of-contents)
  - [Container Configuration](#container-configuration)
  - [PostgreSQL Global](#postgresql-global)
  - [PostgreSQL Performance Configuration](#postgresql-performance-configuration)
  - [PostgreSQL Archive Configuration](#postgresql-archive-configuration)
  - [PostgreSQL Logging](#postgresql-logging)
  - [PostgreSQL Journal Configuration](#postgresql-journal-configuration)
  - [PostgreSQL Replication Configuration](#postgresql-replication-configuration)
  - [PostgreSQL Replication Mode](#postgresql-replication-mode)
  - [Backup Configuration](#backup-configuration)
  - [Snapshot Configuration](#snapshot-configuration)
  - [Standby Configuration](#standby-configuration)
  - [Database configuration](#database-configuration)
  - [Extension Configuration](#extension-configuration)
  - [Migration Configuration](#migration-configuration)
  - [REPMGR Configuration](#repmgr-configuration)

## Container Configuration

| ENVVAR | Default | Description                                                             |
| ------ | ------- | ----------------------------------------------------------------------- |
| TZ     | UTC     | Timezone configuration, use format `Europa/Amsterdam` for configuration |
| PUID   | 1000    | Map user ownership to provided value                                    |
| PGID   | 1000    | Map group ownership to provided value                                   |
| HOME   | /config | Default volume                                                          |

## PostgreSQL Global

| ENVVAR                          | Default                        | Description                                                                        |
| ------------------------------- | ------------------------------ | ---------------------------------------------------------------------------------- |
| PG_HOME                         | /config/data                   | PostgreSQL home                                                                    |
| PG_DATA_DIR                     | /config/data/{VERSION}/main    | PostgreSQL data directory                                                          |
| PG_CERTS_DIR                    | /config/certs                  | Certificate directory                                                              |
| PG_ARCHIVE_DIR                  | /config/archive                | Archive Directory                                                                  |
| PG_CONF                         | ${PG_DATA_DIR}/postgresql.conf | PostgreSQL configuration file                                                      |
| PG_HBA_CONF                     | ${PG_DATA_DIR}/pg_hba.conf     | PostgreSQL HBA configuration file                                                  |
| PG_IDENT_CONF                   | ${PG_DATA_DIR}/pg_ident.conf   | PostgreSQL IDENT configuration file                                                |
| PG_TIMEOUT_STARTUP              | 60                             | Timeout for starting the PostgreSQL server                                         |
| PG_TIMEOUT_SHUTDOWN             | 60                             | Timeout for stopping the PostgreSQL server                                         |
| PG_READY_CONNECT_TIMEOUT        | 120                            | Timeout waiting for PostgreSQL server to be ready for connection while configuring |
| PG_READY_CONNECT_MASTER_TIMEOUT | 60                             | Timeout waiting for connecting to master node                                      |
| PG_SSL                          | off (BOOL)                     | Enable SSL/TLS                                                                     |
| PG_USER                         | postgres                       | Root user                                                                          |
| PG_PASS                         | postgres                       | Root password                                                                      |

## PostgreSQL Performance Configuration

| ENVVAR                      | Default | Description                                                                                                    |
| --------------------------- | ------- | -------------------------------------------------------------------------------------------------------------- |
| PG_MAX_CONNECTIONS          | AUTO    | Max Connections, if set to auto max connection will be calculated by GREATEST(4 x CORES, 100)                  |
| PG_SHARED_BUFFERS           | 128MB   | Set shared buffers, default: 128MB; if set to `AUTO` it will be calculated based upon LEAST(RAM/2, 10GB)       |
| PG_WORK_MEM                 | 4MB     | Work Memory, if set to `AUTO` it will be calculated based upon ((Total RAM - shared_buffers)/(16 x CPU cores)) |
| PG_MAINTENANCE_WORK_MEM     | 64MB    | Maintenance Work Memory                                                                                        |
| PG_EFFECTIVE_IO_CONCURRENCY | 1       | Effective IO Concurrency. Also accepts `SSD` as value, which it will then automatically set to `200`           |
| PG_JOURNAL_WAL_COMPRESSION  | on      | Enabled, because on most servers IO is a greater bottleneck then CPU                                           |
| PG_JOURNAL_WAL_LOG_HINTS    | on      | Enabled to allow `pg_rewind`                                                                                   |
| PG_JOURNAL_WAL_BUFFERS      | 64MB    | PostgreSQL own default is 16MB, with `AUTO` it is based upon shared buffers, with 64MB it recommended          |

## PostgreSQL Archive Configuration

| ENVVAR                      | Default                    | Description                                                                               |
| --------------------------- | -------------------------- | ----------------------------------------------------------------------------------------- |
| PG_ARCHIVE_MODE             | on                         | Enable WAL archiving by default, only disable if you are never going to use WAL archiving |
| PG_ARCHIVE_DIR              | /config/archive            | Archive Directory (Volume Mount)                                                          |
| PG_ARCHIVE_COMMAND          | cp %p ${PG_ARCHIVE_DIR}/%f | Archive Command. By default will copy archive to $PG_ARCHIVE_DIR                          |
| PG_ARCHIVE_COMPRESS         | off                        | Compress archive                                                                          |
| PG_ARCHIVE_COMPRESS_COMMAND | gzip                       | Compress command; Values: `gzip`, `xz`                                                    |
| PG_ARCHIVE_RESTORE_COMMAND  | cp ${PG_ARCHIVE_DIR}/%f %p | Archive restore command                                                                   |

> **Restore Command**
>
> The `restore_command` parameter is only supported from version 12+

> **Important**
>
> The archive compress variable works under the premise that the default archive and restore commands are used.
> If you are providing your own custom command for archiving and restore, turn archive compress off and
> include compression in your own command if so desired.
>
> If archive compression is enabled the archive command is transformed into `gzip|xz < %p > ${PG_ARCHIVE_DIR}/%f`>
>
> If archive compression is enabled the restore command is transformed into `gunzip < ${PG_ARCHIVE_DIR}/%f > %p`

## PostgreSQL Logging

| ENVVAR               | Default               | Description                      |
| -------------------- | --------------------- | -------------------------------- |
| PG_LOG_DIR           | /config/logs/postgres | Log directory                    |
| PG_LOG_COLLECTOR     | on (BOOL)             | Enable log collector             |
| PG_LOG_FILE_MODE     | 0640                  | Set file permission for log file |
| PG_LOG_FILE_ROTATION | 1d                    | Set log file rotation            |

## PostgreSQL Journal Configuration

| ENVVAR                            | Default   | Description                                                                                                                                                                  |
| --------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PG_JOURNAL_WAL_LEVEL              | logical   | WAL level configuration. Value: `replica`, `minimal`, `logical`                                                                                                              |
| PG_JOURNAL_WAL_FSYNC              | on        | WAL fsync                                                                                                                                                                    |
| PG_JOURNAL_WAL_SYNC_METHOD        | fdatasync | WAL sync method                                                                                                                                                              |
| PG_JOURNAL_WAL_SYNCHRONOUS_COMMIT | on        | Synchronous commit: on, off, local, remote_write, remote_apply                                                                                                               |
| PG_JOURNAL_WAL_FULL_PAGE_WRITES   | on        | Full page writes                                                                                                                                                             |
| PG_JOURNAL_WAL_COMPRESSION        | on        | Enabled, because on most servers IO is a greater bottleneck then CPU                                                                                                         |
| PG_JOURNAL_WAL_KEEP_SEGMENTS      | 32        | Amount of WAL segments to keep                                                                                                                                               |
| PG_JOUNRAL_WAL_KEEP_SIZE          | 0         | Wal keep size (v13+) When set to `AUTO` it will calculate the correct value based upon the previous setting `PG_JOURNAL_WAL_KEEP_SEGMENTS` and `PG_JOURNAL_WAL_SEGMENT_SIZE` |
| PG_JOURNAL_WAL_SEGMENT_SIZE       | 16        | WAL Segment size in MB, acn only be changed when initializing database, also must be the same for standby servers                                                            |
| PG_JOURNAL_WAL_LOG_HINTS          | on        | Enabled to allow `pg_rewind`                                                                                                                                                 |
| PG_JOURNAL_WAL_BUFFERS            | 64MB      | PostgreSQL own default is 16MB, with `AUTO` it is based upon shared buffers, with 64MB it recommended                                                                        |
| PG_JOURNAL_MAX_SENDERS            | 10        | Renamed to `REPLICATION_MAX_SENDERS`                                                                                                                                         |

> **wal_level**
>
> Default WAL level is set to `logical` for this container. PostgreSQL defaults normally to `replica`.
>
> Reason: The default is set to `logical` to allow easy migration through 'logical replication'. This will allow adding standby upgrade replication nodes to a existing master.
> It was deemed more beneficial to change this parameter because the overhead does not outweigh the need to easy production database upgrades between versions.

## PostgreSQL Replication Configuration

| ENVVAR                  | Default  | Description                    |
| ----------------------- | -------- | ------------------------------ |
| REPLICATION_MODE        | `null`   | Replication mode               |
| REPLICATION_USER        | `null`   | Replication user               |
| REPLICATION_PASS        | `null`   | Replication password           |
| REPLICATION_HOST        | `null`   | Replication hostname of master |
| REPLICATION_PORT        | 5432     | Replication port               |
| REPLICATION_SSLMODE     | `prefer` | Replication ssl mode           |
| REPLICATION_MAX_SENDERS | 10       | Max WAL senders                |
| REPLICATION_MAX_SLOTS   | 10       | Max replication slots          |

## PostgreSQL Replication Mode

There are multiple replication possibilities.

. Values: `backup`, `snapshot`, `standby`

| Replication Mode | Description                                              |
| ---------------- | -------------------------------------------------------- |
| backup           | Backup mode                                              |
| snapshot         | Snapshot mode                                            |
| standby          | Standby mode; this is a standard PostgreSQL standby node |
| repmgr-witness   | `repmgr` witness mode                                    |
| repmgr-standby   | `repmgr` standby mode                                    |

## Backup Configuration

| ENVVAR                       | Default                   | Description                                                                                                                                                                                                                                                                                                                    |
| ---------------------------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| PG_BACKUP_FORMAT             | plain                     | Backup format. Values: `plain`, `tar`                                                                                                                                                                                                                                                                                          |
| PG_BACKUP_WAL_DIR            | `null`                    | Location for the WAL files                                                                                                                                                                                                                                                                                                     |
| PG_BACKUP_RATE               | `null`                    | Maximum transfer rate to pull data from the master in kilobytes. This is used to not overload the master node when performing a backup. Use suffix `M` for rate in megabytes. Accepted values are between 32 kilobytes per second and 1024 megabytes per second.<br><br> Example 10 megabytes per second means `10M` as value. |
| PG_BACKUP_TAR_COMPRESS       | off (BOOL)                | Compress backup if format is `tar`                                                                                                                                                                                                                                                                                             |
| PG_BACKUP_TAR_COMPRESS_LEVEL | `0`                       | Provide compression level for backup if format is `tar`. Values: 0-9                                                                                                                                                                                                                                                           |
| PG_BACKUP_LABEL              | pg_basebackup base backup | Provide backup label                                                                                                                                                                                                                                                                                                           |
| PG_BACKUP_CHECKPOINT         | fast                      | Set checkpoint mode. Values: `fast`, `spread`                                                                                                                                                                                                                                                                                  |
| PG_BACKUP_STATUS_INTERVAL    | 10                        | Set status interval in seconds                                                                                                                                                                                                                                                                                                 |
| PG_BACKUP_VERBOSE            | off (BOOL)                | Set verbose logging level                                                                                                                                                                                                                                                                                                      |

## Snapshot Configuration

| ENVVAR                      | Default    | Description                                                                                                                                                                                                                                                                                                                    |
| --------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| PG_SNAPSHOT_WAL_DIR         | `null`     | Location for the WAL files                                                                                                                                                                                                                                                                                                     |
| PG_SNAPSHOT_RATE            | `null`     | Maximum transfer rate to pull data from the master in kilobytes. This is used to not overload the master node when performing a backup. Use suffix `M` for rate in megabytes. Accepted values are between 32 kilobytes per second and 1024 megabytes per second.<br><br> Example 10 megabytes per second means `10M` as value. |
| PG_SNAPSHOT_CHECKPOINT      | fast       | Set checkpoint mode. Values: `fast`, `spread`                                                                                                                                                                                                                                                                                  |
| PG_SNAPSHOT_STATUS_INTERVAL | 10         | Set status interval in seconds                                                                                                                                                                                                                                                                                                 |
| PG_SNAPSHOT_VERBOSE         | off (BOOL) | Set verbose logging level                                                                                                                                                                                                                                                                                                      |

## Standby Configuration

| ENVVAR                         | Default    | Description                                                                                                                                                                                                                                                                                                                    |
| ------------------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| PG_STANDBY_WAL_DIR             | `null`     | Location for the WAL files                                                                                                                                                                                                                                                                                                     |
| PG_STANDBY_RATE                | `null`     | Maximum transfer rate to pull data from the master in kilobytes. This is used to not overload the master node when performing a backup. Use suffix `M` for rate in megabytes. Accepted values are between 32 kilobytes per second and 1024 megabytes per second.<br><br> Example 10 megabytes per second means `10M` as value. |
| PG_STANDBY_CHECKPOINT          | fast       | Set checkpoint mode. Values: `fast`, `spread`                                                                                                                                                                                                                                                                                  |
| PG_STANDBY_STATUS_INTERVAL     | 10         | Set status interval in seconds                                                                                                                                                                                                                                                                                                 |
| PG_STANDBY_VERBOSE             | off (BOOL) | Set verbose logging level                                                                                                                                                                                                                                                                                                      |
| PG_STANDBY_HOT                 | off (BOOL) | Enable hot standby                                                                                                                                                                                                                                                                                                             |
| PG_STANDBY_MAX_ARCHIVE_DELAY   | 30s        | Standby max archive delay                                                                                                                                                                                                                                                                                                      |
| PG_STANDBY_MAX_STREAMING_DELAY | 30s        | Stnadby max streaming delay                                                                                                                                                                                                                                                                                                    |

## Database configuration

| ENVVAR         | Default          | Description                                                         |
| -------------- | ---------------- | ------------------------------------------------------------------- |
| PG_INIT_DB_DIR | /config/initdb.d | Database initialization scripts                                     |
| DB_NAME        | `null`           | Databases to be created, `,` comma seperated for multiple databases |
| DB_USER        | `null`           | Database user for all created databases                             |
| DB_PASS        | `null`           | Database password for all created databases                         |
| DB_TEMPLATE    | template1        | Default database template                                           |
| DB_USER_CREATE_PUBLIC | off (BOOL) | Allow user to create objects in schema PUBLIC, changed in PostgreSQL:15 |

## Extension Configuration

| ENVVAR                     | Default    | Description                                         |
| -------------------------- | ---------- | --------------------------------------------------- |
| DB_EXTENSION               | `null`     | Database extensions loaded in the created databases |
| PL_PERL                    | off (BOOL) | Enable PL/Perl language extension                   |
| PL_PYTHON                  | off (BOOL) | Enable PL/Python language extension                 |
| PL_TCL                     | off (BOOL) | Enable PL/Tcl language extensions                   |
| PG_CRON                    | off (BOOL) | Enable pg_cron scheduler extension                  |
| PG_CRON_DB                 | postgres   | Database to load pg_cron into                       |
| PG_CRON_WORKERS_BACKGROUND | off (BOOL) | Enable pg_cron background workers                   |
| PG_CRON_WORKERS_MAX        | 8          | Set maximum amount of pg_cron background workers    |

## Migration Configuration

| ENVVAR                        | Default | Description                                                                         |
| ----------------------------- | ------- | ----------------------------------------------------------------------------------- |
| PG_MIGRATE_DATA_BACKUP        | off     | Create backup of previous PostgreSQL data before migration                          |
| PG_MIGRATE_DATA_BACKUP_REMOVE | off     | Auto remove created additional backup                                               |
| PG_MIGRATE_OLD_DATA_REMOVE    | off     | Auto remove old PostgreSQL data on succesfull migration                             |
| PG_MIGRATE_ANALYSE            | on      | Post run statistics generation to make database usable. Values: `on`, `off`, `fast` |

## REPMGR Configuration

| ENVVAR                              | Default             | Description                                                                                                                                              |
| ----------------------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| REPMGR                              | false               | Enable / disable `repmgr`                                                                                                                                |
| REPMGR_USER                         | repmgr              | `repmgr` username                                                                                                                                        |
| REPMGR_PASS                         | repmgr              | `repmgr` password                                                                                                                                        |
| REPMGR_DB_NAME                      | repmgr              | `repmgr` database name                                                                                                                                   |
| REPMGR_NODE_ID                      | 1                   | Node ID, must be unique, will try automatic calculation                                                                                                  |
| REPMGR_NODE_HOST                    | `hostname -f`       | Hostname of node, can be either IP or FQDN, defaults to `hostname -f`                                                                                    |
| REPMGR_NODE_NAME                    | `hostname -s`       | Node name                                                                                                                                                |
| REPMGR_NODE_PRIMARY                 | `$REPLICATION_HOST` | IP or hostname of the initial primary server, required for initial standby or witness registration, this will default to the `REPLICATION_HOST` variable |
| REPMGR_LOCATION                     | default             | Set location label                                                                                                                                       |
| REPMGR_USE_REPLICATION_SLOTS        | false               | Use physical replication slots                                                                                                                           |
| REPMGR_WITNESS_SYNC_INTERVAL        | 15                  | Interval (seconds) to sync node records to witness server                                                                                                |
| REPMGR_LOG_LEVEL                    | INFO                | Set log level for `repmgr`. Value: `DEBUG`, `INFO`, `NOTICE`, `WARNING`, `ERROR`, `ALERT`, `CRIT`, `EMERG`                                               |
| REPMGR_LOG_STATUS_INTERVAL          | 300                 | Interval (seconds) for repmgrd to log a status message                                                                                                   |
| REPMGR_PROMOTE_CHECK_TIMEOUT        | 60                  | Promote check timeout                                                                                                                                    |
| REPMGR_PROMOTE_CHECK_INTERVAL       | 30                  | Promote check interval                                                                                                                                   |
| REPMGR_PRIMARY_FOLLOW_TIMEOUT       | 60                  | Primary follow timeout                                                                                                                                   |
| REPMGR_STANDBY_FOLLOW_TIMEOUT       | 30                  | Standby follow timeout                                                                                                                                   |
| REPMGR_STANDNY_FOLLOW_RESTART       | false               | Standby follow restart                                                                                                                                   |
| REPMGR_SHUTDOWN_CHECK_TIMEOUT       | 60                  | Shutdown check timeout                                                                                                                                   |
| REPMGR_STANDBY_RECONNECT_TIMEOUT    | 60                  | Standby reconnect timeout                                                                                                                                |
| REPMGR_WAL_RECEIVE_CHECK_TIMEOUT    | 30                  | Wal receive check timeout                                                                                                                                |
| REPMGR_NODE_REJOIN_TIMEOUT          | 60                  | Node rejoin timeout                                                                                                                                      |
| REPMGR_FAILOVER_AUTOMATIC           | true                | When enabled perform automatic failover                                                                                                                  |
| REPMGR_PRIORITY                     | 100                 | Node priority                                                                                                                                            |
| REPMGR_CONNECTION_CHECK_TYPE        | ping                | Connection check type. Values: `ping`, `connection`, `query`                                                                                             |
| REPMGR_RECONNECT_ATTEMPTS           | 6                   | Reconnect attempts                                                                                                                                       |
| REPMGR_RECONNECT_INTERVAL           | 10                  | Reconnect interval in seconds                                                                                                                            |
| REPMGR_PRIMARY_NOTIFICATION_TIMEOUT | 60                  | Notification timeout                                                                                                                                     |
| REPMGR_STANDBY_STARTUP_TIMEOUT      | 60                  | Standby startup timeout                                                                                                                                  |

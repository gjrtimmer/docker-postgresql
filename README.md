# PostgreSQL

Configurable PostgreSQL server with backup,snapshot,standby,hot standby,ssl/tls and much more easy configuration through environment variables.
Including examples to get you started quickly.

- [Quick Start](#quick-start)
- [PostgreSQL Versions](#postgresql-versions)
- [Features](#features)
- [Timezone Configuration](#timezone-configuration)
- [File Permissions](#file-permissions)
- [Persistent Storage](#persistent-storage)
- [Custom Container Initialization](#custom-container-initialization)
- [Custom Services](#custom-services)
- [Creating Databases](#creating-databases)
- [Database Initialization](#database-initialization)
- [Enabling Extensions](#enabling-extensions)
- [Creating a Backup](#creating-a-backup)
- [Creating a Snapshot](#creating-a-snapshot)
- [Creating a Standby Server](#creating-a-standby-server)
- [Environment Variables](#environment-variables)
  - [Container Configuration](#container-configuration)
  - [PostgreSQL Global](#postgresql-global)
  - [PostgreSQL Performance Configuration](#postgresql-performance-configuration)
  - [PostgreSQL Logging](#postgresql-logging)
  - [PostgreSQL Journal Configuration](#postgresql-journal-configuration)
  - [PostgreSQL Replication Configuration](#postgresql-replication-configuration)
  - [Backup Configuration](#backup-configuration)
  - [Snapshot Configuration](#snapshot-configuration)
  - [Standby Configuration](#standby-configuration)
  - [Database configuration](#database-configuration)
  - [Extension Configuration](#extension-configuration)
- [Error Exit Codes](#error-exit-codes)

## Quick Start

```bash
docker run --detach -p 5432:5432 gjrtimmer/postgresql:latest
```

## PostgreSQL Versions

Currently this image supports the following PostgreSQL versions:

- 13 (gjrtimmer/postgresql:13)
- 14 (gjrtimmer/postgresql:14) (latest)

The container is build upon alpine linux from linuxserver.

## Features

The following are the key features, read the full documentation to understand everything which is supported.

| Feature                      | Description                                                                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| host file permissions        | Set data file permissions                                                                                                    |
| backup                       | Easy backup your live running master node with a script or docker-compose file                                               |
| snapshot                     | Create a snapshot of a server and then run it, very handy for developers whom need a clone of a running server to work local |
| standby                      | Add standby nodes to your master                                                                                             |
| hot standby                  | Add hot standby nodes to your master to allow read-only queries to your standby nodes                                        |
| ssl/tls                      | Easy configure SSL/TLS through environment variable                                                                          |
| automatic upgrade/migration  | Automatic database upgrade with migration to new version                                                                     |
| create databases on startup  | Create multiple new databases on container startup                                                                           |
| database template definition | Configure the database template to be used for creating new databases                                                        |
| Database initialization      | Initialize databases on startup with SQL, including support for different SQL files per database                             |
| Extension support            | Load extensions into databases through environment variables                                                                 |
| PL/Perl                      | PL/Perl Language support                                                                                                     |
| PL/Python                    | PL/Python Language support                                                                                                   |
| PL/TCL                       | PL/TCL Language support                                                                                                      |
| pg_cron                      | Enable PG_CRON database scheduler for database cron jobs                                                                     |
| performance configuration    | Performance configuration through environment variables                                                                      |

## Timezone Configuration

Set the timezone for the container, defaults to `UTC`. To set the timezone set the desired timezone with the variable `TZ`.

Please use the timezone database format for configuring the timezone.

Example: `TZ=Europe/Amsterdam`

## File Permissions

This container si based upon alpine linux from linuxserver. This means it comes with full support for the `PUID` and `PGID` variables.

> Using the PUID and PGID allows our containers to map the container's internal user to a user on the host machine.
> All of our containers use this method of user mapping and should be applied accordingly.
>
> More information can be found here: [linuxserver: understanding PUID/PGID](https://docs.linuxserver.io/general/understanding-puid-and-pgid)

| ENVVAR | Default | Description                           |
| ------ | ------- | ------------------------------------- |
| PUID   | 1000    | Map user ownership to provided value  |
| PGID   | 1000    | Map group ownership to provided value |

## Persistent Storage

By default everything is stored in the mount point `/config`. In orer to configure persistent storage the `/config` mount point has to be
mapped either to a volume or host directory.

Some default storage locations can be configured with environment variables. For a complete list see [Environment Variables](#environment-variables).

| ENVVAR         | Default                     | Description                     |
| -------------- | --------------------------- | ------------------------------- |
| HOME           | /config                     | Default volume                  |
| PG_HOME        | /config/data                | PostgreSQL home                 |
| PG_DATA_DIR    | /config/data/{VERSION}/main | PostgreSQL data directory       |
| PG_CERTS_DIR   | /config/certs               | Certificate directory           |
| PG_LOG_DIR     | /config/logs                | Log directory                   |
| PG_INIT_DB_DIR | /config/initdb.d            | Database initialization scripts |

## Custom Container Initialization

Because this image is based upon the alpine linux base image from [linuxserver.io](https://linuxserver.io) its also possible to provide
your own custom initialization scripts for the container.

This can be done by providing your own scripts in the `/config/custom-cont-init.d` directory.

## Custom Services

Because this image is based upon the alpine linux base image from [linuxserver.io](https://linuxserver.io) its also possible to provide
your own custom services within the container.

Custom services can be placed in the `/config/custom-serviced.d` directory.

## Creating Databases

A new PostgreSQL database can be created by specifying the DB_NAME variable while starting the container.

Example: `DB_NAME=dbname`

By default databases are created by copying the standard system database named `template1`. You can specify a different template for your database using the `DB_TEMPLATE` parameter. Refer to [Template Databases](http://www.postgresql.org/docs/12.5/static/manage-ag-templatedbs.html) for further information.

Additionally, more than one database can be created by specifying a comma separated list of database names in `DB_NAME`. For example, setting the `DB_NAME` variable to the following creates two new databases named `dbname1` and `dbname2`.

Example: `DB_NAME=dbname1,dbname2`

## Database Initialization

Because this image is able to initalize multiple database; in several cases you want to be able to initialize a database with tables / indexes etc...

For this scenario this image provides a volume location for database initialization `PG_INIT_DB_DIR` (/config/initdb.d).
In this volume location sql files are expected with the following format `<ID>-<DB_NAME>-<additional name>.sql`.

The ID is an id to order the files for loading in a specific order.

This can be used not only for specific initialization for separate databases but also for global configuration. In the scenario that you start a container which creates a new user with password and 2 databases and you also want to create additional users you can use this database initialization method to create the addtional users.

Example:

```bash
PG_USER=postgres
PG_PASS=********
DB_USER=maintenance
DB_PASS=********
DB_NAME=orders,customers
```

In the example above, 2 databases are created `orders` and `customers` and the user `maintenace` is given access to these databases.

Using this example you can place your sql files like this.

```bash
5-postgres-create-users.sql
10-orders-init.sql
10-orders-create-users.sql
10-customers-init.sql
10-customers-create-users.sql
```

You can even provide sql init files for the main `postgres` database by simply providing its database name in the name of the init script.

## Enabling Extensions

Extensions can be enabled through the `DB_EXTENSION` environment variables. Multiple extensions can be provided by separating them with a `,` comma. Currently the extensions are enabled for every database created with the `DB_NAME` variable.

This container is shipped with the [postgres contrib module](https://www.postgresql.org/docs/14/contrib.html) which includes the following extensions.

[More information about each extension can be found here](https://www.postgresql.org/docs/14/contrib.html).

- adminpack
- amcheck
- autoinc
- bloom
- btree_gin
- btree_gist
- citext
- cube
- dblink
- dict_int
- dict_xsyn
- earthdistance
- file_fdw
- fuzzystrmatch
- hstore
- hstore_plperl
- hstore_plperlu
- hstore_plpython3u
- insert_username
- intagg
- intarray
- isn
- lo
- ltree
- ltree_plpython3u
- moddatetime
- old_snapshot
- pageinspect
- pg_buffercache
- pg_cron (Enabled with: PG_CRON)
- pg_freespacemap
- pg_prewarm
- pg_stat_statements
- pg_surgery
- pg_trgm
- pg_visibility
- pgcrypto
- pgrowlocks
- pgstattuple
- plperl
- plperlu (Enabled with: PL_PERL)
- plpgsql
- plpython3u (Enabled with: PL_PYTHON)
- pltcl
- pltclu (Enabled with: PL_TCL)
- postgres_fdw
- refint
- seg
- sslinfo
- tablefunc
- tcn
- tsm_system_rows
- tsm_system_time
- unaccent
- uuid-ossp
- xml2

## Creating a Backup

The requirements for creating a backup of a PostgreSQL server are that the server allows replication connections and that there are enough wal senders available to send the data to the backup. This means that you can even use this image as a backup image for a PostgreSQL server which does not use this image.

> Backups are generated with the use of `pg_basebackup`

Requirements:

- master node have wal level `replica` or `logical`.
- master must have wal senders available
- master must have a replication user

The backup container must be provided with the `REPLICATION_*` variables in order to connect to the master and create a backup.

To configure a backup container the following variables can be used.

- `REPLICATION_MODE` must be set to `backup`
- [REPLICATION_*](#postgresql-replication-configuration) (Mandatory)
- [PG_BACKUP_*](#backup-configuration) (Optional)

See [examples/backup](examples/backup/) on how to use it.

## Creating a Snapshot

Creating a snapshot is a very handy feature of this container. It will connect to a master clone the database and then run on its own.
The difference between a standby and a snapshot is that a standby is read-only and updated whenever the master data is updated (streaming replication), while a snapshot is read-write and is not updated after the initial snapshot of the data from the master.

This is useful for developers to quickly snapshot the current state of a live database and use it for development/debugging purposes without altering the database on the live instance.

> This is **NOT** a standby server, so after generating the snapshot the master will **NOT** stream any updates.
>
> Snapshots are generated with the use of `pg_basebackup`

The snapshot container must be provided with the `REPLICATION_*` variables in order to connect to the master and create a snapshot.

To configure a snapshot container the following variables can be used.

- `REPLICATION_MODE` must be set to `snapshot`
- [REPLICATION_*](#postgresql-replication-configuration) (Mandatory)
- [PG_SNAPSHOT_*](#snapshot-configuration) (Optional)

See [examples/snapshot](examples/snapshot/) on how to use it.

## Creating a Standby Server

Creating a standby server means that you will have a master which will perform READ/WRITE actions, and all the data is replicated to the standby server(s). This image also supports the creation of `hot` standby servers.

The difference between standby servers and `hot` standby servers is that normal standby servers do not allow any read operation from the database, while a `hot` standby server can be used for read only queries. In both cases WRITE queries still only come through the master.

The standby container must be provided with the `REPLICATION_*` variables in order to connect to the master and receive its updates.

To configure a standby container the following variables can be used.

- `REPLICATION_MODE` must be set to `standby`
- [REPLICATION_*](#postgresql-replication-configuration) (Mandatory)
- [PG_STANDBY_*](#standby-configuration) (Optional)

> If you want a `hot` standby server `PG_STANDBY_HOT` variable can be used.

See [examples/master-standby](examples/master-standby/) on how to use it.

## Environment Variables

Complete overview of all supported environment variables. The environment variables are categorized in order to make the overview easier to read.

> **Boolean Values**
>
> When a variable is listed in the overview with a default value like `off (BOOL)` it means its a boolean value
> for turning on or off a certain feature. All accepted values are case-insensitive.
>
> The following values are accepted:
> ON: `1`, `true`, `TRUE` `enable`, `ENABLE`, `enabled`, `ENABLED`, `on`, `ON`
> OFF: `0`, `false`, `FALSE`, `disable`, `DISABLE`, `disabled`, `DISABLED`, `off`, `OFF`

### Container Configuration

| ENVVAR | Default | Description                                                             |
| ------ | ------- | ----------------------------------------------------------------------- |
| TZ     | UTC     | Timezone configuration, use format `Europa/Amsterdam` for configuration |
| PUID   | 1000    | Map user ownership to provided value                                    |
| PGID   | 1000    | Map group ownership to provided value                                   |
| HOME   | /config | Default volume                                                          |

### PostgreSQL Global

| ENVVAR                          | Default                        | Description                                                                        |
| ------------------------------- | ------------------------------ | ---------------------------------------------------------------------------------- |
| PG_HOME                         | /config/data                   | PostgreSQL home                                                                    |
| PG_DATA_DIR                     | /config/data/{VERSION}/main    | PostgreSQL data directory                                                          |
| PG_CERTS_DIR                    | /config/certs                  | Certificate directory                                                              |
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

### PostgreSQL Performance Configuration

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
| PG_ARCHIVE_MODE             | on      | Enable WAL archiving by default, only disable if you are never going to use WAL archiving                      |

### PostgreSQL Logging

| ENVVAR               | Default      | Description                      |
| -------------------- | ------------ | -------------------------------- |
| PG_LOG_DIR           | /config/logs | Log directory                    |
| PG_LOG_COLLECTOR     | on (BOOL)    | Enable log collector             |
| PG_LOG_FILE_MODE     | 0640         | Set file permission for log file |
| PG_LOG_FILE_ROTATION | 1d           | Set log file rotation            |

### PostgreSQL Journal Configuration

| ENVVAR                         | Default | Description                                                                                           |
| ------------------------------ | ------- | ----------------------------------------------------------------------------------------------------- |
| PG_JOURNAL_WAL_LEVEL           | replica | WAL level configuration. Value: `replica`, `minimal`, `logical`                                       |
| PG_JOURNAL_WAL_KEEP_SEGMENTS   | 32      | Amount of WAL segments to keep                                                                        |
| PG_JOURNAL_WAL_COMPRESSION     | on      | Enabled, because on most servers IO is a greater bottleneck then CPU                                  |
| PG_JOURNAL_WAL_LOG_HINTS       | on      | Enabled to allow `pg_rewind`                                                                          |
| PG_JOURNAL_WAL_BUFFERS         | 64MB    | PostgreSQL own default is 16MB, with `AUTO` it is based upon shared buffers, with 64MB it recommended |
| PG_JOURNAL_MAX_SENDERS         | 10      | Max WAL senders                                                                                       |
| PG_JOURNAL_CHECKPOINT_SEGMENTS | 8       | WAL Checkpoints                                                                                       |

### PostgreSQL Replication Configuration

| ENVVAR              | Default  | Description                                               |
| ------------------- | -------- | --------------------------------------------------------- |
| REPLICATION_MODE    | `null`   | Replication mode. Values: `backup`, `snapshot`, `standby` |
| REPLICATION_USER    | `null`   | Replication user                                          |
| REPLICATION_PASS    | `null`   | Replication password                                      |
| REPLICATION_HOST    | `null`   | Replication hostname of master                            |
| REPLICATION_PORT    | 5432     | Replication port                                          |
| REPLICATION_SSLMODE | `prefer` | Replication ssl mode                                      |

### Backup Configuration

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

### Snapshot Configuration

| ENVVAR                      | Default    | Description                                                                                                                                                                                                                                                                                                                    |
| --------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| PG_SNAPSHOT_WAL_DIR         | `null`     | Location for the WAL files                                                                                                                                                                                                                                                                                                     |
| PG_SNAPSHOT_RATE            | `null`     | Maximum transfer rate to pull data from the master in kilobytes. This is used to not overload the master node when performing a backup. Use suffix `M` for rate in megabytes. Accepted values are between 32 kilobytes per second and 1024 megabytes per second.<br><br> Example 10 megabytes per second means `10M` as value. |
| PG_SNAPSHOT_CHECKPOINT      | fast       | Set checkpoint mode. Values: `fast`, `spread`                                                                                                                                                                                                                                                                                  |
| PG_SNAPSHOT_STATUS_INTERVAL | 10         | Set status interval in seconds                                                                                                                                                                                                                                                                                                 |
| PG_SNAPSHOT_VERBOSE         | off (BOOL) | Set verbose logging level                                                                                                                                                                                                                                                                                                      |

### Standby Configuration

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

### Database configuration

| ENVVAR         | Default          | Description                                                         |
| -------------- | ---------------- | ------------------------------------------------------------------- |
| PG_INIT_DB_DIR | /config/initdb.d | Database initialization scripts                                     |
| DB_NAME        | `null`           | Databases to be created, `,` comma seperated for multiple databases |
| DB_USER        | `null`           | Database user for all created databases                             |
| DB_PASS        | `null`           | Database password for all created databases                         |
| DB_TEMPLATE    | template1        | Default database template                                           |

### Extension Configuration

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

## Error Exit Codes

| Code | Description                                                                     | Resolution                                                       |
| ---- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| 10   | Failed to install old PostgreSQL version for data migration                     | TODO                                                             |
| 15   | Required variable `DB_USER` not set                                             | Add environment variable DB_USER to container                    |
| 16   | Required variable `DB_PASS` not set                                             | Add environment variable DB_PASS to container                    |
| 17   | Required variable `DB_NAME` not set                                             | Add environment variable DB_NAME to container                    |
| 18   | Required variable `REPLICATION_HOST` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_HOST` to container         |
| 19   | Required variable `REPLICATION_USER` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_USER` to container         |
| 20   | Required variable `REPLICATION_PASS` not set while `REPLICATION_MODE` is active | Add environment variable `REPLICATION_PASS` to container         |
| 30   | Timeout while connecting to REPLICATION_HOST                                    | Ensure network connection to Replication Host van be established |
| 41   | Certificate not found `PG_CERTS_DIR/server.crt`                                 | Place certificate in correct path                                |
| 42   | Invalid permissions for `PG_CERTS_DIR/server.crt`                               | File permissions for server.crt needs to be set to `644`         |
| 43   | Certificate not found `PG_CERTS_DIR/server.key`                                 | Place certificate in correct path                                |
| 44   | Invalid permissions for `PG_CERTS_DIR/server.key`                               | File permissions for server.key needs to be set to `640`         |
| 50   | Backup completed succesfully                                                    | N.A.                                                             |
| 51   | Backup failed                                                                   | Check log file                                                   |
| 52   | Invalid option for PG_BACKUP_FORMAT                                             | Valid options: `p|plain` or `t|tar`                              |
| 61   | Snapshot failed                                                                 | Check logfile                                                    |

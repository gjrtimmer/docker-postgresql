# PostgreSQL

Configurable PostgreSQL server with backup,snapshot,standby,hot standby,ssl/tls and much more easy configuration through environment variables.
Including examples to get you started quickly. The source code for this repository can be found here on GitHub [gjrtimmer/docker-postgresql](https://github.com/gjrtimmer/docker-postgresql).

## Table of Contents

- [Quick Start](#quick-start)
- [PostgreSQL Versions](#postgresql-versions)
- [Features](#features)
- [Environment variables](#environment-variables)
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
- [Automatic failover / cluster management](#automatic-failover--cluster-management)

## Quick Start

```bash
docker run --detach -p 5432:5432 gjrtimmer/postgresql:latest
```

## PostgreSQL Versions

Currently this repository supports the following PostgreSQL versions:

- 9 (gjrtimmer/postgresql:9)
- 10 (gjrtimmer/postgresql:10)
- 11 (gjrtimmer/postgresql:11)
- 12 (gjrtimmer/postgresql:12)
- 13 (gjrtimmer/postgresql:13)
- 14 (gjrtimmer/postgresql:14)
- 15 (gjrtimmer/postgresql:15) (latest)

The container is build upon alpine linux from linuxserver.

## Features

The following are the key features, read the full documentation to understand everything which is supported.

| Feature                      | Description                                                                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Host file permissions        | Set data file permissions                                                                                                    |
| Backup                       | Easy backup your live running master node with a script or docker-compose file                                               |
| Snapshot                     | Create a snapshot of a server and then run it, very handy for developers whom need a clone of a running server to work local |
| Standby                      | Add standby nodes to your master                                                                                             |
| Hot Standby                  | Add hot standby nodes to your master to allow read-only queries to your standby nodes                                        |
| TLS/SSL                      | Easy configure SSL/TLS through environment variable                                                                          |
| Automatic upgrade/migration  | Automatic database upgrade with migration to new version                                                                     |
| Create databases on startup  | Create multiple new databases on container startup                                                                           |
| Database template definition | Configure the database template to be used for creating new databases                                                        |
| Database initialization      | Initialize databases on startup with SQL, including support for different SQL files per database                             |
| Extension support            | Load extensions into databases through environment variables                                                                 |
| PL/Perl                      | PL/Perl Language support                                                                                                     |
| PL/Python                    | PL/Python Language support                                                                                                   |
| PL/TCL                       | PL/TCL Language support                                                                                                      |
| pg_cron                      | Enable PG_CRON database scheduler for database cron jobs                                                                     |
| Performance configuration    | Performance configuration through environment variables                                                                      |
| Automatic cluster management | Automatic cluster management with `repmgr`                                                                                   |

## Environment variables

For a full list of features / environment variables, please look here [Environment Variables](docs/ENVIRONMENT.md)

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

Some default storage locations can be configured with environment variables. For a complete list see [Environment Variables](docs/ENVIRONMENT.md).

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

Custom services can be placed in the `/config/custom-services.d` directory.

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

This container is shipped with the [postgres contrib module](https://www.postgresql.org/docs/15/contrib.html) which includes the following extensions.

[More information about each extension can be found here](https://www.postgresql.org/docs/15/contrib.html).

A full list of the extensions can be found here [Extension Overview](docs/EXTENSIONS.md)

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
- [REPLICATION_*](docs/ENVIRONMENT.md#postgresql-replication-configuration) (Mandatory)
- [PG_BACKUP_*](docs/ENVIRONMENT.md#backup-configuration) (Optional)

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
- [REPLICATION_*](docs/ENVIRONMENT.md#postgresql-replication-configuration) (Mandatory)
- [PG_SNAPSHOT_*](docs/ENVIRONMENT.md#snapshot-configuration) (Optional)

See [examples/snapshot](examples/snapshot/) on how to use it.

## Creating a Standby Server

Creating a standby server means that you will have a master which will perform READ/WRITE actions, and all the data is replicated to the standby server(s). This image also supports the creation of `hot` standby servers.

The difference between standby servers and `hot` standby servers is that normal standby servers do not allow any read operation from the database, while a `hot` standby server can be used for read only queries. In both cases WRITE queries still only come through the master.

The standby container must be provided with the `REPLICATION_*` variables in order to connect to the master and receive its updates.

To configure a standby container the following variables can be used.

- `REPLICATION_MODE` must be set to `standby`
- [REPLICATION_*](docs/ENVIRONMENT.md#postgresql-replication-configuration) (Mandatory)
- [PG_STANDBY_*](docs/ENVIRONMENT.md#standby-configuration) (Optional)

> If you want a `hot` standby server `PG_STANDBY_HOT` variable can be used.

See [examples/master-standby](examples/master-standby/) on how to use it.

## Automatic failover / cluster management

This image provides [repmgr](https://repmgr.org/) as cluster manager for automatic cluster orchestration and cluster failover/management.

> **IMPORTANT**
>
> Please note that while `repmgr` can be used in production, the implementation within the image has not been fully tested.
> Several dependecies for using `repmgr` like `SSH` access etc is still being implemented.
>
> Use at your own risk

`repmgr` can be enabled with the variable `REPMGR=enabled`.

For more configuration options for `repmgr` see the [REPMGR Configuration](docs/REPMGR.md#repmgr-configuration).

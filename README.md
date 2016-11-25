[![build status](https://gitlab.timmertech.nl/docker/alpine-postgresql/badges/master/build.svg)](https://gitlab.timmertech.nl/docker/alpine-postgresql/commits/master)

# docker/alpine-postgresql:9.6.0

<br>
# Image details:
- Alpine Linux: 3.4
- S6-Overlay: 1.18.1.5
- Postgresql: 9.6.0-r1

<br>
# Index

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Volume Locations](#volume-locations)
  - [Configuration Options](#configuration-options)
    - [General Options](#general-options)
	- [Replication Options](#replication-options)
  - [Persistence](#persistence)
  - [Trusting local connections](#trusting-local-connections)
  - [Setting `postgres` user password](#setting-postgres-user-password)
  - [Creating database user](#creating-database-user)
  - [Creating databases](#creating-databases)
  - [Granting user access to a database](#granting-user-access-to-a-database)
  - [Enabling extensions](#enabling-extensions)
  - [Creating replication user](#creating-replication-user)
  - [Setting up a replication cluster](#setting-up-a-replication-cluster)
  - [Create a slave node](#create-a-slave-node)
  - [Creating a snapshot](#creating-a-snapshot)
  - [Creating a backup](#creating-a-backup)
  - [UID/GID mapping](#uidgid-mapping)

<br>
# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [PostgreSQL](http://postgresql.org/).

PostgreSQL is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards-compliance [[source](https://en.wikipedia.org/wiki/PostgreSQL)].

<br>
# Getting Started

```bash
docker pull registry.timmertech.nl/docker/alpine-postgresql
```

<br> 
## Volume Locations

Default Locations:

| Type | Location |
|------|----------|
| Data Directory | /var/lib/postgresql |
| Log Directory | /var/log/postgresql |
| Run Directory | /var/run/postgresql |

<br>
## Configuration Options

<br>
### General Options

| Option | Description |
|--------|-------------|
| [PG_UID](#uidgid-mapping) `UID` | Map ownership to UID |
| [PG_GID](#uidgid-mapping) `GID` | Map ownership to GID |
| [PG_TRUST_LOCALNET](#trusting-local-connections) `BOOL` | Enabling, will trust connections from the local network (default: false) |
| [PG_PASSWORD](#setting-postgres-user-password) `PASS` | Password for `postgres` user |
| [DB_USER](#creating-database-user) `USER` | Username for database(s) provided with `DB_NAME` |
| [DB_PASS](#creating-database-user) `PASS` | Password for database(s) provided with `DB_NAME` |
| [DB_NAME](#creating-databases) `NAME` | Database(s) to create, multiple can be provided separated with a comma `,` |
| [DB_TEMPLATE](http://www.postgresql.org/docs/9.4/static/manage-ag-templatedbs.html) `TEMPLATE` | Template to use for newly created database(s) [Template Databases](http://www.postgresql.org/docs/9.4/static/manage-ag-templatedbs.html) |
| [DB_EXTENSION](#enabling-extensions) `EXTENSION` | Extension to enable for database(s) within `DB_NAME`, multiple can be provided separated with a comma `,` |

<br>
### Replication Options

| Option | Description |
|--------|-------------|
| [REPLICATION_USER](#creating-replication-user) `USER` | Username for the replication user |
| [REPLICATION_PASS](#creating-replication-user) `PASS` | Password for the replication user |
| REPLICATION_MODE `MODE` | Replication mode: [slave](#create-a-slave-node) / [snapshot](#creating-a-snapshot) / [backup](#creating-a-backup) (default: master) [Details](https://www.postgresql.org/docs/current/static/libpq-ssl.html) |
| [REPLICATION_HOST](#setting-up-a-replication-cluster) `HOST` | Replication host |
| [REPLICATION_PORT](#setting-up-a-replication-cluster) `POST` | Port number of replication host (default: 5432) |
| [REPLICATION_SSLMODE](#setting-up-a-replication-cluster) `MODE` | SSL Mode for Replication (default: prefer) |

<br>
## Persistence

For PostgreSQL to preserve its state across container shutdown and startup you should mount a volume at `/var/lib/postgresql`.

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/postgresql
chcon -Rt svirt_sandbox_file_t /srv/docker/postgresql
```

<br>
## Trusting local connections

By default connections to the PostgreSQL server need to authenticated using a password. If desired you can trust connections from the local network using the `PG_TRUST_LOCALNET` variable.

```bash
docker run --name postgresql -itd --restart always \
  --env 'PG_TRUST_LOCALNET=true' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

> **Note**
>
> The local network here is network to which the container is attached. This has different meanings depending on the `--net` parameter specified while starting the container. In the default configuration, this parameter would trust connections from other containers on the `docker0` bridge.

<br>
## Setting `postgres` user password

By default the `postgres` user is not assigned a password and as a result you can only login to the PostgreSQL server locally. If you wish to login remotely to the PostgreSQL server as the `postgres` user, you will need to assign a password for the user using the `PG_PASSWORD` variable.

```bash
docker run --name postgresql -itd --restart always \
  --env 'PG_PASSWORD=passw0rd' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

<br>
## Creating database user

A new PostgreSQL database user can be created by specifying the `DB_USER` and `DB_PASS` variables while starting the container.

```bash
docker run --name postgresql -itd --restart always \
  --env 'DB_USER=dbuser' --env 'DB_PASS=dbuserpass' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

> **Notes**
>
> - The created user can login remotely
> - The container will error out if a password is not specified for the user
> - No changes will be made if the user already exists
> - Only a single user can be created at each launch

<br>
## Creating databases

A new PostgreSQL database can be created by specifying the `DB_NAME` variable while starting the container.

```bash
docker run --name postgresql -itd --restart always \
  --env 'DB_NAME=dbname' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

By default databases are created by copying the standard system database named `template1`. You can specify a different template for your database using the `DB_TEMPLATE` parameter. Refer to [Template Databases](http://www.postgresql.org/docs/9.4/static/manage-ag-templatedbs.html) for further information.

Additionally, more than one database can be created by specifying a comma separated list of database names in `DB_NAME`. For example, the following command creates two new databases named `dbname1` and `dbname2`.

```bash
docker run --name postgresql -itd --restart always \
  --env 'DB_NAME=dbname1,dbname2' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

<br>
## Granting user access to a database

If the `DB_USER` and `DB_PASS` variables are specified along with the `DB_NAME` variable, then the user specified in `DB_USER` will be granted access to all the databases listed in `DB_NAME`. Note that if the user and/or databases do not exist, they will be created.

```bash
docker run --name postgresql -itd --restart always \
  --env 'DB_USER=dbuser' --env 'DB_PASS=dbuserpass' \
  --env 'DB_NAME=dbname1,dbname2' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

In the above example `dbuser` with be granted access to both the `dbname1` and `dbname2` databases.

<br>
# Enabling extensions

The image also packages the [postgres contrib module](http://www.postgresql.org/docs/9.4/static/contrib.html). A comma separated list of modules can be specified using the `DB_EXTENSION` parameter.

```bash
docker run --name postgresql -itd \
  --env 'DB_NAME=db1,db2' --env 'DB_EXTENSION=unaccent,pg_trgm' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

The above command enables the `unaccent` and `pg_trgm` modules on the databases listed in `DB_NAME`, namely `db1` and `db2`.

> **NOTE**:
>
> This option deprecates the `DB_UNACCENT` parameter.

<br>
## Creating replication user

Similar to the creation of a database user, a new PostgreSQL replication user can be created by specifying the `REPLICATION_USER` and `REPLICATION_PASS` variables while starting the container.

```bash
docker run --name postgresql -itd --restart always \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

> **Notes**
>
> - The created user can login remotely
> - The container will error out if a password is not specified for the user
> - No changes will be made if the user already exists
> - Only a single user can be created at each launch

*It is a good idea to create a replication user even if you are not going to use it as it will allow you to setup slave nodes and/or generate snapshots and backups when the need arises.*

<br>
## Setting up a replication cluster

When the container is started, it is by default configured to act as a master node in a replication cluster. This means that you can scale your PostgreSQL database backend when the need arises without incurring any downtime. However do note that a replication user must exist on the master node for this to work.

Begin by creating the master node of our cluster:

```bash
docker run --name postgresql-master -itd --restart always \
  --env 'DB_USER=dbuser' --env 'DB_PASS=dbuserpass' --env 'DB_NAME=dbname' \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

Notice that no additional arguments are specified while starting the master node of the cluster.

To create a replication slave the `REPLICATION_MODE` variable should be set to `slave` and additionally the `REPLICATION_HOST`, `REPLICATION_PORT`, `REPLICATION_SSLMODE`, `REPLICATION_USER` and `REPLICATION_PASS` variables should be specified.

<br>
## Create a slave node

```bash
docker run --name postgresql-slave01 -itd --restart always \
  --link postgresql-master:master \
  --env 'REPLICATION_MODE=slave' --env 'REPLICATION_SSLMODE=prefer' \
  --env 'REPLICATION_HOST=master' --env 'REPLICATION_PORT=5432'  \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

*In the above command, we used docker links so that we can address the master node using the `master` alias in `REPLICATION_HOST`.*

> **Note**
>
> - The default value of `REPLICATION_PORT` is `5432`
> - The default value of `REPLICATION_SSLMODE` is `prefer`
> - The value of `REPLICATION_USER` and `REPLICATION_PASS` should be the same as the ones specified on the master node.
> - With [persistence](#persistence) in use, if the container is stopped and started, for the container continue to function as a slave you need to ensure that `REPLICATION_MODE=slave` is defined in the containers environment. In the absense of which the slave configuration will be turned off and the node will allow writing to it while having the last synced data from the master.

And just like that with minimal effort you have a PostgreSQL replication cluster setup. You can create additional slaves to scale the cluster horizontally.

Here are some important notes about a PostgreSQL replication cluster:

 - Writes can only occur on the master
 - Slaves are read-only
 - For best performance, limit the reads to the slave nodes

<br>
## Creating a snapshot
> **Untested**
> Reason: S6 Implementation

Similar to a creating replication slave node, you can create a snapshot of the master by specifying `REPLICATION_MODE=snapshot`.

Once the master node is created as specified in [Setting up a replication cluster](#setting-up-a-replication-cluster), you can create a snapshot using:

```bash
docker run --name postgresql-snapshot -itd --restart always \
  --link postgresql-master:master \
  --env 'REPLICATION_MODE=snapshot' --env 'REPLICATION_SSLMODE=prefer' \
  --env 'REPLICATION_HOST=master' --env 'REPLICATION_PORT=5432'  \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

The difference between a slave and a snapshot is that a slave is read-only and updated whenever the master data is updated (streaming replication), while a snapshot is read-write and is not updated after the initial snapshot of the data from the master.

This is useful for developers to quickly snapshot the current state of a live database and use it for development/debugging purposes without altering the database on the live instance.

<br>
## Creating a backup
> **Untested**
> Reason: S6 Implementation

Just as the case of setting up a slave node or generating a snapshot, you can also create a backup of the data on the master by specifying `REPLICATION_MODE=backup`.

> The backups are generated with [pg_basebackup](http://www.postgresql.org/docs/9.4/static/app-pgbasebackup.html) using the replication protocol.

Once the master node is created as specified in [Setting up a replication cluster](#setting-up-a-replication-cluster), you can create a point-in-time backup using:

```bash
docker run --name postgresql-backup -it --rm \
  --link postgresql-master:master \
  --env 'REPLICATION_MODE=backup' --env 'REPLICATION_SSLMODE=prefer' \
  --env 'REPLICATION_HOST=master' --env 'REPLICATION_PORT=5432'  \
  --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
  --volume /srv/docker/backups/postgresql.$(date +%Y%m%d%H%M%S):/var/lib/postgresql \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

Once the backup is generated, the container will exit and the backup of the master data will be available at `/srv/docker/backups/postgresql.XXXXXXXXXXXX/`. Restoring the backup involves starting a container with the data in `/srv/docker/backups/postgresql.XXXXXXXXXXXX`.

<br>
# UID/GID mapping

The files and processes created by the container are owned by the `postgres` user that is internal to the container. In the absense of user namespace in docker the UID and GID of the containers `postgres` user may have different meaning on the host.

For example, a user on the host with the same UID and/or GID as the `postgres` user of the container will be able to access the data in the persistent volumes mounted from the host as well as be able to KILL the `postgres` server process started by the container.

To circumvent this issue you can specify the UID and GID for the `postgres` user of the container using the `PG_UID` and `PG_GID` variables respectively.

For example, if you want to assign the `postgres` user of the container the UID and GID `999`:

```bash
docker run --name postgresql -itd --restart always \
  --env 'PG_UID=999' --env 'PG_GID=999' \
  registry.timmertech.nl/docker/apline-postgresql:9.6.0
```

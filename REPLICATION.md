[![build status](https://gitlab.timmertech.nl/docker/alpine-postgresql/badges/master/build.svg)](https://gitlab.timmertech.nl/docker/alpine-postgresql/commits/master)

# docker/alpine-postgresql:9.6.1

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
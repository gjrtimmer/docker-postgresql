[![build status](https://gitlab.timmertech.nl/docker/alpine-postgresql/badges/master/build.svg)](https://gitlab.timmertech.nl/docker/alpine-postgresql/commits/master)

# docker/alpine-postgresql

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Locations](#locations)
  - [Configuration Options](#configuration-options)

# Introduction
  
# Getting Started

```bash
docker pull registry.timmertech.nl/docker/alpine-postgresql
```

# Locations

Default Locations:

| Type | Location |
|------|----------|
| Data Directory | /var/lib/postgresql |
| Log Directory | /var/log/postgresql |

# Configuration Options

| Option | Description |
|--------|-------------|
| PG_UID `UID` | Map ownership to UID |
| PG_GID `GID` | Map ownership to GID |

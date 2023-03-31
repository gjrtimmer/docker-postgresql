# Contribute

This repsoitory uses git [conventional commits](https://www.conventionalcommits.org/).

For commits the following types are used:

- fix
- bug
- feat
- chore
- build
- test
- docs
- ops

## Configure Local Repository

### Configure environment

The the following command from the {PROJECT_ROOT}.

```bash
git config include.path ../.gitaliases
git setup
```

### Configure Local Docker Network

```bash
docker network create --subnet=172.50.0.0/16 --ip-range=172.50.50.1/24 --gateway=172.50.0.1 platform
```

## Development

If you want to know which commands are available please run:

```bash
make help
```

### Build everything

```bash
make all
```

### Build latest

```bash
make build
```

### Run latest

```bash
make run
```

### Shell into container

```bash
make shell
```

### Clean data of latest container

```bash
make clean
```

### Specific version

All the previous commands can also be run for a specific version. Each make command can be appended with `-<VERSION>`. So to build only the PostgreSQL version 14 container one can issue `make build-14`. For more commands related to a specific version run `make help`.

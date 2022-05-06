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

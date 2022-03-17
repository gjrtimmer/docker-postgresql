## Master

Start a master node with `docker-compose`.

```bash
cd master
PUID=$(id -u) PGID=$(id -g) docker-compose up
```

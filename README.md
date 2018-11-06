# Socat proxy in Docker

[Socat proxy](https://hub.docker.com/r/binlab/socat) based on `socat`
tool which proxies `unix://` socket to `tcp://` socket.

This is useful when you need to expose the `unix://` socket through
`tcp`.

## Usage cases

### 1. `Docker` daemon through `TCP`

Docker example:

```bash
$ docker run \
    --rm \
    --name socat-docker \
    -v /var/run/docker.sock:/var/run/docker.sock:rw \
    --network host \
    --user root \
    binlab/socat
```

Docker-compose example:

```yaml
  socat-docker:
    image: binlab/socat
    container_name: socat-docker
    hostname: socat-docker
    restart: always
    user: root
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:rw
    network_mode: host
```

And then connect to the Docker:

```bash
$ curl http://127.0.0.1:2375/version
```

#### Remark

You should use `root` user for run `socat` inside a container as a
`root` because my image built to run `socat` with no privileged user.
In this case is important in that by default `docker` socket runs
with next permissions:

```bash
srw-rw----. 1 root docker 0 Jan 1 00:00 /var/run/docker.sock
```

Next way is change a permissions for `/var/run/docker.sock`

### 2. Forwarding host daemon to inside a `Docker` network

For example, this is can be useful when you need to access inside a
`Docker` of legacy service from a host bonded on `unix://` socket.

Docker example:

```bash
$ docker run \
    --name socat-redis \
    -v /tmp/redis.sock:/var/run/docker.sock:rw \
    binlab/socat
```

Docker-compose example:

```yaml
  socat-redis:
    image: binlab/socat
    container_name: socat-redis
    hostname: socat-redis
    restart: always
    volumes:
      - /tmp/redis.sock:/var/run/docker.sock:rw
```

And then connect to the conteiner:

```bash
$ docker run --rm --network docker_default alpine:3.8 nc -v socat-redis 2375
```

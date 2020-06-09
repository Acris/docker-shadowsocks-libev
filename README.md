# Shadowsocks-libev Dockerfile
This Dockerfile build an image for [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev/) with [v2ray-plugin](https://github.com/shadowsocks/v2ray-plugin), based on Alpine Linux.

Current version:
- shadowsocks-libev: v3.3.4
- v2ray-plugin: v1.3.1


## Quick Start

Get the docker image by running the following commands:

```bash
docker pull acrisliu/shadowsocks-libev
```

Start a instance:

```bash
docker run -d --name=shadowsocks-libev -p 8388:8388/tcp -p 8388:8388/udp --restart=always acrisliu/shadowsocks-libev
```


## Setting a specific configration

You can use environment variables to specific configration.

For example, start a container with encrypt method `aes-256-gcm` and password `YourPassword`:

```bash
docker run -d \
-e METHOD=aes-256-gcm \
-e PASSWORD=YourPassword \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

Available environment variables and default values:

- `SERVER_ADDRS`: Host name or ip address of your remote server, default value is `0.0.0.0`.
- `SERVER_PORT`: Port number of your remote server, default value is `8388`.
- `PASSWORD`: Password of your remote server, default value is `ChangeMe!!!`.
- `METHOD`: Encrypt method, default value is `chacha20-ietf-poly1305`.
- `TIMEOUT`: Socket timeout in seconds, default value is `86400`.
- `DNS_ADDRS`: Setup name servers for internal DNS resolver, default value is `1.1.1.1,1.0.0.1`.
- `ARGS`: Additional arguments supported by `ss-server`, default value is `-u`, to enable UDP relay.


## Enable v2ray-plugin
By default, v2ray-plugin is disabled, use `ARGS` environment variable with `--plugin`, `--plugin-opts` arguments to enable it.

For example, if you want to enable v2ray-plugin with TLS mode and enable UDP relay:
```sh
docker run -d \
-e "ARGS=--plugin v2ray-plugin --plugin-opts server;tls;host=yourdomain.com;path=/v2ray;cert=/root/.acme.sh/yourdomain.com/fullchain.cer;key=/root/.acme.sh/yourdomain.com/yourdomain.com.key -u" \
-e PASSWORD=YourPassword \
-v /root/.acme.sh:/root/.acme.sh \
--user root \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```


Enable v2ray-plugin with QUIC mode:
```sh
docker run -d \
-e "ARGS=--plugin v2ray-plugin --plugin-opts server;mode=quic;host=yourdomain.com;path=/v2ray;cert=/root/.acme.sh/yourdomain.com/fullchain.cer;key=/root/.acme.sh/yourdomain.com/yourdomain.com.key" \
-e PASSWORD=YourPassword \
-v /root/.acme.sh:/root/.acme.sh \
--user root \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

*Attentions: if you want to enable v2ray-plugin QUIC mode, you must disable the UDP relay of ss-server, without `-u` argument in `ARGS`.*

Remember mount your certs to container, recommend use [acme.sh](acme.sh) to issue certs.

For more v2ray-plugin configrations please go to [v2ray plugin docs](https://github.com/shadowsocks/v2ray-plugin/blob/master/README.md)


## With docker-compose
docker-compose.yml:
```yml
version: "3.7"
services:
  shadowsocks-libev:
    container_name: shadowsocks-libev
    image: acrisliu/shadowsocks-libev:latest
    user: root
    ports:
      - "8388:8388/tcp"
      - "8388:8388/udp"
    volumes:
      - /root/.acme.sh:/root/.acme.sh:ro
    environment:
      - PASSWORD=YourPassword
      - ARGS=--plugin v2ray-plugin --plugin-opts server;tls;host=yourdomain.com;path=/v2ray;cert=/root/.acme.sh/yourdomain.com/fullchain.cer;key=/root/.acme.sh/yourdomain.com/yourdomain.com.key -u
    restart: always
```


## How to upgrade

Just use bellow commands:

```bash
# Pull the latest image
docker pull acrisliu/shadowsocks-libev
# Stop and remove old container
docker stop shadowsocks-libev
docker rm shadowsocks-libev
# Start a new container with the latest image
docker run -d \
-e PASSWORD=YourPassword \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

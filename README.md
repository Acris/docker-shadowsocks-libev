# Shadowsocks-libev Dockerfile
This Dockerfile build an image for [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev/) with [simple-obfs](https://github.com/shadowsocks/simple-obfs), based on Alpine Linux.

Current version:
- shadowsocks-libev: v3.2.1
- simple-obfs: v0.0.5


## Quick Start

Get the docker image by running the following commands:

```bash
docker pull acrisliu/shadowsocks-libev
```

Start a instance:

```bash
docker run -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp --restart=always acrisliu/shadowsocks-libev
```


## Default configration

Server host: `0.0.0.0`  
Server port: `8388`  
Password: `shadowsocks`  
Encrypt method: `chacha20-ietf-poly1305`  
Timeout: `600`  
DNS: `8.8.8.8`  
Plugin: `obfs-server`  
Plugin options: `obfs=tls`  


## Simple-obfs plugin configration

```bash
--plugin obfs-server
--plugin-opts "obfs=tls"
```

On the client, use this configuration:

```bash
--plugin obfs-local
--plugin-opts "obfs=tls;obfs-host=www.bing.com"
```


## Setting a specific configration

You can use environment variables to specific configration.

For example with encrypt method `aes-256-cfb` and password `MyPassword`:

```bash
docker run -e ENCRYPT_METHOD=aes-256-cfb -e PASSWORD=MyPassword -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp --restart=always acrisliu/shadowsocks-libev
```

Available environment variables:

- `SERVER_HOST`: Host name or ip address of your remote server
- `SERVER_PORT`: Port number of your remote server
- `PASSWORD`: Password of your remote server
- `ENCRYPT_METHOD`: Encrypt method
- `TIMEOUT`: Socket timeout in seconds
- `DNS_ADDR`: Setup name servers for internal DNS resolver
- `PLUGIN`: Enable SIP003 plugin
- `PLUGIN_OPTS`: Set SIP003 plugin options


## How to upgrade

Just use boellow commands:

```bash
# Pull the latest image
docker pull acrisliu/shadowsocks-libev
# Stop and remove old container
docker stop shadowsocks-libev
docker rm shadowsocks-libev
# Start a new container with latest image
docker run -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp --restart=always acrisliu/shadowsocks-libev
```

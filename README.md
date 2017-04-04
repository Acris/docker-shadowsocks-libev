# Shadowsocks-libev Dockerfile
This Dockerfile builds an image with the [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev/) and [simple-obfs](https://github.com/shadowsocks/simple-obfs). Based on Arch Linux image.


## Quick Start

Get the docker image by running the following commands:

```bash
docker pull acrisliu/shadowsocks-libev
```

Start a instance:

```bash
docker run -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp acrisliu/shadowsocks-libev
```


## Default configration

Server host: `0.0.0.0`  
Server port: `8388`  
Password: `shadowsocks`  
Encrypt method: `chacha20`  
Timeout: `60`  
DNS: `8.8.8.8`  


## Simple-obfs plugin parameter

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

You can use these environment variables to specific configration:
- `ENCRYPT_METHOD` is the encrypt method
- `PASSWORD` is the password

For example with encrypt method `aes-256-cfb` with password `MyPassword`:

```bash
docker run -e ENCRYPT_METHOD=aes-256-cfb -e PASSWORD=MyPassword -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp acrisliu/shadowsocks-libev
```

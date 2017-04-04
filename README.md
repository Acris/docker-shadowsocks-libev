# docker-shadowsocks-libev
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


## Setting a specific configration

You can use these environment variables to specific configration:
- `ENCRYPT_METHOD` is the encrypt method
- `PASSWORD` is the password

For example with encrypt method `aes-256-cfb` with password `MyPassword`:

```bash
docker run -e ENCRYPT_METHOD=aes-256-cfb -e PASSWORD=MyPassword -d --name=shadowsocks-libev -p 3389:8388/tcp -p 3389:8388/udp acrisliu/shadowsocks-libev
```

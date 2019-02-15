# Shadowsocks-libev Dockerfile
This Dockerfile build an image for [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev/) with [v2ray-plugin](https://github.com/shadowsocks/v2ray-plugin), based on Alpine Linux.

Current version:
- shadowsocks-libev: v3.2.3
- v2ray-plugin: v1.0


## Quick Start

Get the docker image by running the following commands:

```bash
docker pull acrisliu/shadowsocks-libev
```

Start a instance:

```bash
docker run -d --name=shadowsocks-libev -p 8388:8388/tcp -p 8388:8388/udp --restart=always acrisliu/shadowsocks-libev
```


## Default configration

Server host: `0.0.0.0`    
Server port: `8388`    
Password: `shadowsocks`    
Encrypt method: `chacha20-ietf-poly1305`    
Timeout: `600`    
DNS: `1.1.1.1`    


## Setting a specific configration

You can use environment variables to specific configration.

For example with encrypt method `aes-256-cfb` and password `MyPassword`:

```bash
docker run -d \
-e ENCRYPT_METHOD=aes-256-cfb \
-e PASSWORD=MyPassword \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

Available environment variables:

- `SERVER_HOST`: Host name or ip address of your remote server
- `SERVER_PORT`: Port number of your remote server
- `PASSWORD`: Password of your remote server
- `ENCRYPT_METHOD`: Encrypt method
- `TIMEOUT`: Socket timeout in seconds
- `DNS_ADDR`: Setup name servers for internal DNS resolver
- `PLUGIN`: Enable SIP003 plugin, only support v2ray-plugin.
- `PLUGIN_OPTS`: Set SIP003 plugin options, only support v2ray-plugin options.


## Enable v2ray-plugin
By default, v2ray-plugin is disabled, to enable it, use `-e PLUGIN=v2ray-plugin` and `-e PLUGIN_OPTS=your-plugin-options`.

For example, if you want to enable quic mode:
```sh
docker run -d \
-e PLUGIN=v2ray-plugin \
-e PLUGIN_OPTS=server;mode=quic;host=yourdomain.com \
-e PASSWORD=MyPassword \
-v /home/username/.acme.sh:/root/.acme.sh
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

Remember mount your certs to container.

For more v2ray-plugin configrations please go to [v2ray plugin docs](https://github.com/shadowsocks/v2ray-plugin/blob/master/README.md)


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
-e PASSWORD=MyPassword \
--name=shadowsocks-libev \
-p 8388:8388/tcp \
-p 8388:8388/udp \
--restart=always \
acrisliu/shadowsocks-libev
```

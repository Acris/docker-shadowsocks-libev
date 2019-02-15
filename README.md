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
docker run -e ENCRYPT_METHOD=aes-256-cfb -e PASSWORD=MyPassword -d --name=shadowsocks-libev -p 8388:8388/tcp -p 8388:8388/udp --restart=always acrisliu/shadowsocks-libev
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

OSee command line args for advanced usages.

### Shadowsocks over websocket (HTTP)

On your server

```sh
ss-server -c config.json -p 80 --plugin v2ray-plugin --plugin-opts "server"
```

On your client

```sh
ss-local -c config.json -p 80 --plugin v2ray-plugin
```

### Shadowsocks over websocket (HTTPS)

On your server

```sh
ss-server -c config.json -p 443 --plugin v2ray-plugin --plugin-opts "server;tls;host=mydomain.me"
```

On your client

```sh
ss-local -c config.json -p 443 --plugin v2ray-plugin --plugin-opts "tls;host=mydomain.me"
```

### Shadowsocks over quic

On your server

```sh
ss-server -c config.json -p 443 --plugin v2ray-plugin --plugin-opts "server;mode=quic;host=mydomain.me"
```

On your client

```sh
ss-local -c config.json -p 443 --plugin v2ray-plugin --plugin-opts "mode=quic;host=mydomain.me"
```

### Issue a cert for TLS and QUIC

```sh
curl  https://get.acme.sh | sh
sudo apt-get -y install socat
sudo ~/.acme.sh/acme.sh --issue -d mydomain.me --standalone -k 4096
```

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
docker run -d --name=shadowsocks-libev -p 8388:8388/tcp -p 8388:8388/udp --restart=always acrisliu/shadowsocks-libev
```

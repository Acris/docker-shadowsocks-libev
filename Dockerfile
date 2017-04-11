FROM archimg/base

MAINTAINER Acris Liu "acrisliu@gmail.com"

# Environment variables
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD shadowsocks
ENV ENCRYPT_METHOD chacha20
ENV TIMEOUT 60
ENV DNS_ADDR 8.8.8.8
ENV PLUGIN obfs-server
ENV PLUGIN_OPTS obfs=tls

# Install shadowsocks-libev and simple-obfs
RUN pacman --noconfirm -Syu shadowsocks-libev simple-obfs

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

# Start shadowsocks-libev server
ENTRYPOINT ss-server \
-s "$SERVER_HOST" \
-p "$SERVER_PORT" \
-k "$PASSWORD" \
-m "$ENCRYPT_METHOD" \
-t "$TIMEOUT" \
-d "$DNS_ADDR" \
--plugin "$PLUGIN" \
--plugin-opts "$PLUGIN_OPTS" \
-u \
--fast-open \
--reuse-port

FROM alpine

MAINTAINER Acris Liu "acrisliu@gmail.com"

ENV SHADOWSOCKS_LIBEV_VERSION v3.0.5
ENV SIMPLE_OBFS_VERSION v0.0.3

# Build shadowsocks-libev and simple-obfs
RUN set -ex \

    # Install dependencies
    && apk add --no-cache --virtual .build-deps \
               autoconf \
               automake \
               build-base \
               libev-dev \
               libtool \
               linux-headers \
               udns-dev \
               libsodium-dev \
               mbedtls-dev \
               pcre-dev \
               tar \
               udns-dev \
               git \

    # Build shadowsocks-libev
    && mkdir -p /tmp/build-shadowsocks-libev \
    && cd /tmp/build-shadowsocks-libev \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git checkout "$SHADOWSOCKS_LIBEV_VERSION" \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --disable-documentation \
    && make install \
    && ssRunDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/ss-server \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .ss-rundeps $ssRunDeps \
    && cd / \
    && rm -rf /tmp/build-shadowsocks-libev \

    # Build simple-obfs
    && mkdir -p /tmp/build-simple-obfs \
    && cd /tmp/build-simple-obfs \
    && git clone https://github.com/shadowsocks/simple-obfs.git \
    && cd simple-obfs \
    && git checkout "$SIMPLE_OBFS_VERSION" \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --disable-documentation \
    && make install \
    && simpleObfsRunDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/obfs-server \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .simple-obfs-rundeps $simpleObfsRunDeps \
    && cd / \
    && rm -rf /tmp/build-simple-obfs \
    
    # Delete dependencies
    && apk del .build-deps

# Shadowsocks environment variables
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD shadowsocks
ENV ENCRYPT_METHOD chacha20
ENV TIMEOUT 60
ENV DNS_ADDR 8.8.8.8
ENV PLUGIN obfs-server
ENV PLUGIN_OPTS obfs=tls

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

# Start shadowsocks-libev server
ENTRYPOINT ss-server -s "$SERVER_HOST" \
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

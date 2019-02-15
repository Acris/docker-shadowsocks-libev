FROM golang:alpine AS golang

ENV V2RAY_PLUGIN_VERSION v1.0

RUN apk add --no-cache git \
    && go get -d -v github.com/shadowsocks/v2ray-plugin \
	&& cd /go/src/github.com/shadowsocks/v2ray-plugin \
	&& git checkout "$V2RAY_PLUGIN_VERSION" \
	&& go build

FROM alpine

LABEL maintainer="acrisliu@gmail.com"

ENV SHADOWSOCKS_LIBEV_VERSION v3.2.3

# Build shadowsocks-libev
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
               c-ares-dev \
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
    # Delete dependencies
    && apk del .build-deps

# Copy v2ray-plugin
COPY --from=golang /go/src/github.com/shadowsocks/v2ray-plugin/v2ray-plugin /usr/local/bin

# Shadowsocks environment variables
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD shadowsocks
ENV ENCRYPT_METHOD chacha20-ietf-poly1305
ENV TIMEOUT 600
ENV DNS_ADDR 1.1.1.1

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
                     --mptcp \
                     --reuse-port \
                     --fast-open \
                     --no-delay
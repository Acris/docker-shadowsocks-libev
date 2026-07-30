FROM golang:1.26-alpine AS golang

ENV V2RAY_PLUGIN_VERSION=v5.49.0
ENV GO111MODULE=on

# Build v2ray-plugin
RUN apk add --no-cache git build-base \
    && mkdir -p /go/src/github.com/teddysun \
    && cd /go/src/github.com/teddysun \
    && git clone https://github.com/teddysun/v2ray-plugin.git \
    && cd v2ray-plugin \
    && git checkout "$V2RAY_PLUGIN_VERSION" \
    && go get -d \
    && go build

FROM alpine:3.17

LABEL maintainer="Acris Liu <acrisliu@gmail.com>"

ENV SHADOWSOCKS_LIBEV_VERSION=v3.3.6

# Build shadowsocks-libev
RUN set -ex \
    # Install dependencies
    && apk add --no-cache --virtual .build-deps \
               autoconf \
               automake \
               cmake \
               build-base \
               libev-dev \
               libtool \
               linux-headers \
               udns-dev \
               libsodium-dev \
               mbedtls-dev \
               pcre-dev \
               libcap \
               tar \
               udns-dev \
               pcre2-dev \
               c-ares-dev \
               git \
    # Build shadowsocks-libev
    && mkdir -p /tmp/build-shadowsocks-libev \
    && cd /tmp/build-shadowsocks-libev \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git checkout "$SHADOWSOCKS_LIBEV_VERSION" \
    && git submodule update --init --recursive \
    && mkdir -p build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTING=OFF -DWITH_STATIC=OFF -DCMAKE_BUILD_TYPE=Release \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && cd /usr/local/bin \
    && ls /usr/local/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
    && strip $(scanelf --nobanner -E ET_DYN -E ET_EXEC /usr/local/bin/ss-* | awk '{print $2}') \
    && apk del .build-deps \
    # Runtime dependencies setup
    && apk add --no-cache \
         ca-certificates \
         rng-tools \
         tzdata \
         $(scanelf --needed --nobanner /usr/local/bin/ss-* \
         | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
         | sort -u) \
    && rm -rf /tmp/build-shadowsocks-libev

# Copy v2ray-plugin
COPY --from=golang /go/src/github.com/teddysun/v2ray-plugin/v2ray-plugin /usr/local/bin

# Shadowsocks environment variables
ENV SERVER_PORT=8388
ENV PASSWORD=ChangeMe!!!
ENV METHOD=chacha20-ietf-poly1305
ENV TIMEOUT=86400
ENV DNS_ADDRS=1.1.1.1,1.0.0.1,2606:4700:4700::1111,2606:4700:4700::1001
ENV ARGS=-u

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Run as nobody
USER nobody

# Start shadowsocks-libev server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

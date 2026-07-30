#!/bin/sh
set -eu

exec ss-server \
    -s 0.0.0.0 \
    -s ::0 \
    -p "$SERVER_PORT" \
    -k "$PASSWORD" \
    -m "$METHOD" \
    -t "$TIMEOUT" \
    -d "$DNS_ADDRS" \
    --reuse-port \
    --no-delay \
    $ARGS

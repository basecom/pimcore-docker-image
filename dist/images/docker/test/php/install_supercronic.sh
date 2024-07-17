#!/bin/bash

set -e

# Copied from https://github.com/aptible/supercronic/releases

SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.30/supercronic-linux-amd64
SUPERCRONIC=supercronic-linux-amd64
SUPERCRONIC_SHA1SUM=9f27ad28c5c57cd133325b2a66bba69ba2235799

if [ "$(uname -m)" = "aarch64" ]; then
    SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.30/supercronic-linux-arm64
    SUPERCRONIC=supercronic-linux-arm64
    SUPERCRONIC_SHA1SUM=d5e02aa760b3d434bc7b991777aa89ef4a503e49
fi

curl -fsSLO "$SUPERCRONIC_URL"

echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c -

chmod +x "$SUPERCRONIC"

mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}"

ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

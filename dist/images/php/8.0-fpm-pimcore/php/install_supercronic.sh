#!/bin/bash

set -e

# Copied from https://github.com/aptible/supercronic/releases

SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64
SUPERCRONIC=supercronic-linux-amd64
SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8

if [ "$(uname -m)" = "aarch64" ]; then
    SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-arm64
    SUPERCRONIC=supercronic-linux-arm64
    SUPERCRONIC_SHA1SUM=e0f0c06ebc5627e43b25475711e694450489ab00
fi

curl -fsSLO "$SUPERCRONIC_URL"

echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c -

chmod +x "$SUPERCRONIC"

mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}"

ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

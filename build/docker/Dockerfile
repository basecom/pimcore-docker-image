FROM alpine AS builder

RUN apk add curl \
    qemu-img \
    qemu-system-$(uname -m)

RUN curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-$(uname -m) -o /docker-compose \
 && chmod +x /docker-compose


FROM docker:stable

COPY --from=builder /docker-compose /usr/libexec/docker/cli-plugins/docker-compose
COPY --from=builder /usr/bin/qemu-system-* /usr/bin/

# We currently must use the master version to get support for the default config file location, see:
# https://github.com/docker/buildx/commit/8257a04a7d2802890855fdfe262800a563abdecf
COPY --from=docker/buildx-bin:master /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Use buildkitd.toml as default for buildx commands
# See https://github.com/docker/buildx/blob/master/docs/reference/buildx_create.md#-specify-a-configuration-file-for-the-buildkitd-daemon---config
ENV BUILDX_CONFIG=/etc/buildkit
ADD files/docker/buildkitd.toml $BUILDX_CONFIG/buildkitd.default.toml

RUN docker buildx version
RUN docker compose version

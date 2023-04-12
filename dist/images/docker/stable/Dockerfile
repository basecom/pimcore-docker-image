ARG DOCKER_VERSION

FROM alpine AS builder

RUN apk add curl \
    qemu-img \
    qemu-system-$(uname -m)

RUN curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-$(uname -m) -o /docker-compose \
    && chmod +x /docker-compose

FROM docker:$DOCKER_VERSION

COPY --from=builder /docker-compose /usr/libexec/docker/cli-plugins/docker-compose
COPY --from=builder /usr/bin/qemu-system-* /usr/bin/

COPY --from=docker/buildx-bin:0.10.4 /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Use buildkitd.toml as default for buildx commands
# See https://github.com/docker/buildx/blob/master/docs/reference/buildx_create.md#-specify-a-configuration-file-for-the-buildkitd-daemon---config
ENV BUILDX_CONFIG=/etc/buildkit
ENV BUILDX_NO_DEFAULT_ATTESTATIONS=true
COPY ./buildkitd.toml $BUILDX_CONFIG/buildkitd.default.toml

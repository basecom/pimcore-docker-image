ARG DOCKER_VERSION

FROM alpine AS builder

RUN apk add qemu-img \
    qemu-system-$(uname -m)

FROM docker:$DOCKER_VERSION

COPY --from=builder /usr/bin/qemu-system-* /usr/bin/

COPY --from=docker/buildx-bin:0.10.4 /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Use buildkitd.toml as default for buildx commands
# See https://github.com/docker/buildx/blob/master/docs/reference/buildx_create.md#-specify-a-configuration-file-for-the-buildkitd-daemon---config
ENV BUILDX_CONFIG=/etc/buildkit
ENV BUILDX_NO_DEFAULT_ATTESTATIONS=true
COPY ./buildkitd.toml $BUILDX_CONFIG/buildkitd.default.toml

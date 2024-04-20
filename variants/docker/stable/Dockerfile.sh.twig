FROM alpine AS builder

RUN apk add qemu-img \
    qemu-system-$(uname -m)

FROM docker:26

COPY --from=builder /usr/bin/qemu-system-* /usr/bin/

# Use buildkitd.toml as default for buildx commands
# See https://github.com/docker/buildx/blob/master/docs/reference/buildx_create.md#-specify-a-configuration-file-for-the-buildkitd-daemon---config
ENV BUILDX_CONFIG=/etc/buildkit
ENV BUILDX_NO_DEFAULT_ATTESTATIONS=true
COPY ./buildkitd.toml $BUILDX_CONFIG/buildkitd.default.toml

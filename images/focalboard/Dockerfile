# Dockerfile for Focalboard

FROM alpine:latest AS builder
ARG VERSION

RUN apk update && apk add gzip tar wget

# Now install Focalboard as a seperate layer
RUN wget https://github.com/mattermost/focalboard/releases/download/v${VERSION}/focalboard-server-linux-amd64.tar.gz \
    && tar -xvzf focalboard-server-linux-amd64.tar.gz

FROM ubuntu:20.04

RUN adduser --disabled-password --gecos "" focalboard \
    && mkdir -p /data/files && chown focalboard:focalboard /data

USER focalboard

COPY --from=builder --chown=focalboard:focalboard /focalboard /opt/focalboard
COPY --chown=focalboard:focalboard entrypoint.sh /entrypoint.sh

EXPOSE 8000

WORKDIR /data

CMD ["/entrypoint.sh"]

# Dockerfile for Focalboard

FROM alpine:latest AS builder

RUN apk update && apk add gzip tar wget

# Now install Focalboard as a seperate layer
RUN wget https://github.com/mattermost/focalboard/releases/download/v0.6.1/focalboard-server-linux-amd64.tar.gz \
    && tar -xvzf focalboard-server-linux-amd64.tar.gz

FROM ubuntu:20.04

RUN adduser --disabled-password --gecos "" focalboard

USER focalboard

COPY --from=builder --chown=focalboard:focalboard /focalboard /opt/focalboard

RUN sed -i 's/"telemetry": true/"telemetry": false/g' /opt/focalboard/config.json

EXPOSE 8000

WORKDIR /opt/focalboard

CMD /opt/focalboard/bin/focalboard-server

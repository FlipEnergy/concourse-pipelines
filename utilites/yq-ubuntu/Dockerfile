# Dockerfile for yq

FROM ubuntu:20.04
ARG VERSION

RUN apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/mikefarah/yq/releases/download/v${VERSION}/yq_linux_amd64 -O /usr/bin/yq \
  && chmod +x /usr/bin/yq

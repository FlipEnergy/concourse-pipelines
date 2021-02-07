# Dockerfile for bitwarden cli + jq

FROM node:13-alpine
ARG VERSION

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app

RUN npm install --prefix /home/node/app -g "@bitwarden/cli@${VERSION}"

RUN apk add --no-cache jq

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PATH=$PATH:/home/node/app/bin

ENTRYPOINT [ "/home/node/app/bin/bw" ]

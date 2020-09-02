#!/bin/sh -e

alias bw=/home/node/app/bin/bw

echo "Installing jq..."
apk add -q jq
echo

echo "Logging in..."
bw config server bitwarden.pleasenoddos.com

export BW_SESSION=`bw login $BW_USERNAME $BW_PASSWORD --raw`

echo "Getting secret key..."
bw get item $BW_ITEM | jq -r '.notes' | base64 -d > secret.key

echo "secret.key written"

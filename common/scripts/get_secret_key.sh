#!/bin/sh -e

echo "Logging in..."
bw config server $BW_SERVER

export BW_SESSION=`bw login $BW_USERNAME $BW_PASSWORD --raw`

mkdir -p secrets

echo "Getting secret key..."
bw get item $BW_ITEM | jq -r '.notes' | base64 -d > secrets/secret.key

ls -lh secrets/secret.key

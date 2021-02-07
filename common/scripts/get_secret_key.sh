#!/bin/sh -e

echo "Logging in..."
bw config server $BW_SERVER

export BW_SESSION=`bw login $BW_USERNAME $BW_PASSWORD --raw`

mkdir -p tmp_dir

echo "Getting secret key..."
bw get item $BW_ITEM | jq -r '.notes' | base64 -d > tmp_dir/secret.key

ls -lh tmp_dir/secret.key

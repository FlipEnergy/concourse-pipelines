#!/bin/sh -e

echo "Logging in..."
bw config server $BW_SERVER

export BW_SESSION=`bw login $BW_USERNAME $BW_PASSWORD --raw`

mkdir -p secrets

echo "Getting secret key..."
bw get item $BW_ITEM | jq -r '.notes' | base64 -d > secrets/secret.key

# exit 1 if file empty
if ! test -s secrets/secret.key ; then
  echo 'key not written' 
  exit 1
fi

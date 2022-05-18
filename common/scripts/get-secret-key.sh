#!/bin/sh -e

echo "Logging in..."
bw config server "$BW_SERVER"

mkdir -p secrets

echo "Getting secret key..."

retries=5
while [ "$retries" -gt 0 ]; do
  export BW_SESSION=`bw login "$BW_USERNAME" "$BW_PASSWORD" --raw`

  bw get item "$BW_ITEM" | jq -r '.notes' | base64 -d > secrets/secret.key

  if test -s secrets/secret.key ; then
    exit 0
  fi
  echo 'key not written, retrying'
  retries=$((retries - 1))
  sleep 1
done
exit 1

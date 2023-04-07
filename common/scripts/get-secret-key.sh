#!/bin/sh -e

echo "Logging in..."
bw config server "$BW_SERVER"

mkdir -p secrets

echo "Getting bitwarden secret..."

retries=10
while [ "$retries" -gt 0 ]; do
  if [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw login "$BW_USERNAME" "$BW_PASSWORD" --raw)
  fi

  bw get item "$BW_ITEM" | jq -r '.notes' | base64 -d > secrets/secret.txt

  if test -s secrets/secret.txt ; then
    echo 'Got the goods'
    exit 0
  fi
  echo 'file not written, retrying'
  retries=$((retries - 1))
  sleep $((10 - retries))
done
exit 1

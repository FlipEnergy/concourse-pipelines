#!/bin/sh -e

echo "Logging in..."
bw config server "$BW_SERVER"

mkdir -p secrets

echo "Getting bitwarden secret..."


for field in $BW_FIELDS; do
  retries=10
  while [ "$retries" -gt 0 ]; do
    if [ -z "$BW_SESSION" ]; then
      echo "Making session"
      export BW_SESSION=$(bw login "$BW_USERNAME" "$BW_PASSWORD" --raw)
    fi

    echo "Getting ${field}..."
    bw get item "$BW_ITEM" | jq -r ".$field" > secrets/"$field".txt

    if test -s secrets/"$field".txt ; then
      echo 'Got the goods'
      break
    fi

    echo 'file not written, retrying'
    retries=$((retries - 1))
    sleep $((10 - retries))
  done
done




exit 1

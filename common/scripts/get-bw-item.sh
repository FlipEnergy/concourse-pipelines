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

  for field in $BW_FIELDS; do
    echo "Getting ${field}..."
    bw get item "$BW_ITEM" | jq -r ".$field" > secrets/"$field".txt

    if test -s secrets/"$field".txt ; then
      echo 'Got the goods'
      continue
    fi

    echo 'file not written, retrying'
    retries=$((retries - 1))
    sleep $((10 - retries))
  done

done
exit 1

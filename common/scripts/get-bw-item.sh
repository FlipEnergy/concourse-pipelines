#!/bin/sh -e

echo "Logging in..."
bw config server "$BW_SERVER"

mkdir -p secrets

echo "Getting bitwarden secret..."

echo "Making session"
export BW_SESSION=$(bw login "$BW_USERNAME" "$BW_PASSWORD" --raw)

for field in $BW_FIELDS; do
  for i in {1..3}; do
    echo "Getting ${field}..."
    bw get item "$BW_ITEM" | jq -r ".${field}" > "secrets/${field}.txt"

    if test -s "secrets/$field.txt" ; then
      echo 'Got the goods'
      break
    fi

    echo 'file not written, retrying'
    sleep 1
    if [ $i -eq 3 ]; then
      echo 'Failed to get secret'
      exit 1
    fi
  done
done

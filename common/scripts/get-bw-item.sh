#!/bin/sh -e

echo "Logging in..."
bw config server "$BW_SERVER"

mkdir -p secrets

echo "Getting bitwarden secret..."

echo "Making session"
export BW_SESSION=$(bw login "$BW_USERNAME" "$BW_PASSWORD" --raw)

for item in $BW_ITEMS; do
  for i in {1..3}; do
    echo "Getting ${item}..."
    item_id=${item%%:*}
    item_output=${item#*:}
    bw get item "$item_id" | jq -r ".notes" > "secrets/${item_output}"

    if test -s "secrets/${item_output}" ; then
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

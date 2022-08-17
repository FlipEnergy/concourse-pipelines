#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd "${REPO_DIR}"
echo

retries=3
while [ "$retries" -gt 0 ]; do
  if helmsman --no-banner -p 3 "$ACTION" -f "${KUBE_CONTEXT}.yaml"; then
    exit 0
  fi
  echo
  echo 'Retrying...'
  retries=$((retries - 1))
done
exit 1

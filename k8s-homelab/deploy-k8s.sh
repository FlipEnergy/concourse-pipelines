#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd "${REPO_DIR}"
echo

helmsman --no-banner -p 3 --apply -f "${KUBE_CONTEXT}.yaml"

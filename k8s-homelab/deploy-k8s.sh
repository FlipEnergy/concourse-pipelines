#!/usr/bin/env bash -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd "${REPO_DIR}"
echo

helmsman --no-banner -p 3 --apply -f "${DSF_FILE}"

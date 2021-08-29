#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd "${REPO_DIR}"
echo

sops -d ingress-nginx/secret.default-ssl-certs.yaml | kubectl --context "$KUBE_CONTEXT" -n default apply -f -
helmsman --no-banner -p 3 --apply -f "${KUBE_CONTEXT}.yaml"

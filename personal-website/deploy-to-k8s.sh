#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

export DENNIS_SITE_VERSION=$(cat "${REPO_DIR}/.git/short_ref")

cd "${REPO_DIR}/helm_chart"

echo

kubectl config use-context "${KUBE_CONTEXT}"
helm dep update

echo
echo "Deploying version: [${DENNIS_SITE_VERSION}]"
echo
helm upgrade -i -n default dennis-site . --set-string "image.tag=${DENNIS_SITE_VERSION}" --wait

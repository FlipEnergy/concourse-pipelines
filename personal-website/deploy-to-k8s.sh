#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

export DENNIS_SITE_VERSION=$(cat "${REPO_DIR}/.git/short_ref")

cd "${REPO_DIR}/helm_chart"

echo

kubectl config use-context "${KUBE_CONTEXT}"
helm repo add bjw-s https://bjw-s.github.io/helm-charts

echo
echo "Deploying version: [${DENNIS_SITE_VERSION}]"
echo
helm upgrade -i -n default dennis-site bjw-s/app-template --version 1.2.0 -f values.yaml --set-string "image.tag=${DENNIS_SITE_VERSION}" --wait

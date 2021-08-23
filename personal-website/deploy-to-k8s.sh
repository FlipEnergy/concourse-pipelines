#!/usr/bin/env bash
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

export DENNIS_SITE_VERSION=`cat "${REPO_DIR}/.git/short_ref"`

cd "${REPO_DIR}/helm_chart"
echo

echo "Deploying version: ${DENNIS_SITE_VERSION}"

kubectl config use-context "${KUBE_CONTEXT}"
kubectl create ns dennis-site || true
helm dep update
helm upgrade -i -n dennis-site dennis-site . --set "image.tag=${DENNIS_SITE_VERSION}" --wait

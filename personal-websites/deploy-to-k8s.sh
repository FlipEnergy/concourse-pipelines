#!/usr/bin/env sh
set -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

APP_TEMPLATE_VERSION=5.1.0

export SITE_VERSION=$(cat "${REPO_DIR}/.git/short_ref")

cd "${REPO_DIR}/helm_chart"

echo

kubectl config use-context "${KUBE_CONTEXT}"
helm repo add bjw-s https://bjw-s-labs.github.io/helm-charts

echo
echo "Deploying version: [${SITE_VERSION}]"
echo
helm upgrade -i -n default "${RELEASE_NAME} bjw-s/app-template --version "${APP_TEMPLATE_VERSION} -f values.yaml --set-string "controllers.main.containers.main.image.tag=${SITE_VERSION}" --wait

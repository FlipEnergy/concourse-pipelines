#!/bin/sh -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

export DENNIS_SITE_VERSION=`cat personal-website-repo/.git/short_ref`

cd personal-website-repo/helm_chart
echo

kubectl config use-context oracle
kubectl create ns dennis-site || true
helm dep update
helm upgrade -i -n dennis-site dennis-site . --set image.tag=${DENNIS_SITE_VERSION} --wait

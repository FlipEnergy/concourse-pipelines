#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-repo/.git/short_ref`

echo "Importing secret key..."
gpg --import secrets/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/misc/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd personal-website-repo/helm_chart
echo

kubectl create ns dennis-site || true
helm dep update
helm upgrade -i -n dennis-site dennis-site . --set image.tag=${DENNIS_SITE_VERSION} --wait

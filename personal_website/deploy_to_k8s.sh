#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-version-update/version`

echo "Importing secret key..."
gpg --import concourse-pipelines-repo/personal_website/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d personal-website-version-update/kube_config.enc.yml > ~/.kube/config

cd personal-website-version-update
echo

helmsman --apply -f dennis-site-DSF.yaml

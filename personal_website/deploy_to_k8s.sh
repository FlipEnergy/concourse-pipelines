#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-version-bump/version`

echo "Importing secret key..."
gpg --import concourse-pipelines-repo/common/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d personal-website-version-bump/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd personal-website-version-bump
echo

helmsman -no-ns --apply -f dennis-site-DSF.yaml

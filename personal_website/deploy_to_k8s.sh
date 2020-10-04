#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-repo/version`

echo "Importing secret key..."
gpg --import concourse-pipelines-repo/common/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d personal-website-repo/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd personal-website-repo
echo

helmsman --apply -f dennis-site-DSF.yaml

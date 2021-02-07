#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-version-bump/version`

echo "Importing secret key..."
gpg --import tmp_dir/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/misc/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd personal-website-version-bump
echo

helmsman --apply -f dennis-site-DSF.yaml

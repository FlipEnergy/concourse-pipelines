#!/bin/sh -e

export DENNIS_SITE_VERSION=`cat personal-website-repo-version/version`

echo "Importing secret key..."
gpg --import concourse-pipelines-repo/personal_website/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d personal-website-repo-version/kube_config.enc.yml > ~/.kube/config

echo "Getting pods for dennis-site..."
kubectl -n dennis-site get pods

cd personal-website-repo-version
echo

helmsman --apply -f dennis-site-DSF.yaml

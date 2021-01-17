#!/bin/sh -e

echo "Importing secret key..."
gpg --import concourse-pipelines-repo/common/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd k8s-homelab-repo
echo

helmsman -p 3 --apply -f homelab.yaml

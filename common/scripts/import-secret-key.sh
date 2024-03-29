#!/usr/bin/env sh

echo "Importing secret key..."
gpg --import secrets/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/misc/kube-config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

#!/usr/bin/env sh

echo "Importing secret key..."
gpg --import secrets/notes.txt

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/misc/kube-config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

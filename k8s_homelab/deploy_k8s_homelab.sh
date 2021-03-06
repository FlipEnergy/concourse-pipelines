#!/bin/sh -e

echo "Importing secret key..."
gpg --import secrets/secret.key

echo "Decrypting kubectl config..."
mkdir -p ~/.kube
sops -d concourse-pipelines-repo/common/misc/kube_config.enc.yml > ~/.kube/config
chmod 600 ~/.kube/config

cd k8s-homelab-repo
echo

kubectl get configmap -n kube-system coredns -o json | sed "s+/etc/resolv.conf+${PIHOLE_SERVER_IP}+g" | kubectl apply -f -
helmsman --no-banner -p 3 --apply -f homelab.yaml

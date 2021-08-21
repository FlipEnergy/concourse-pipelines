#!/bin/sh -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd k8s-homelab-repo
echo

kubectl get configmap -n kube-system coredns -o json | sed "s+/etc/resolv.conf+${PIHOLE_SERVER_IP}+g" | kubectl apply -f -
helmsman --no-banner -p 3 --apply -f homelab.yaml

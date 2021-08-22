#!/bin/sh -e

concourse-pipelines-repo/common/scripts/import-secret-key.sh

cd k8s-homelab-repo
echo

helmsman --no-banner -p 3 --apply -f ${DSF_FILE}

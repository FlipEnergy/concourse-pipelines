#!/bin/sh -e

echo 'Packaging...'
helm package ${CHART_REPO_INPUT}/${CHART_NAME}

echo 'Writing commit message...'
chart_version=$(ls -1t ${CHART_NAME}-*.tgz | head -n 1)
echo ${chart_version} > k8s-homelab-helm-repo/git_commit_msg

echo 'Moving chart to helm repo...'
mv -vf ${CHART_NAME}-*.tgz k8s-homelab-helm-repo/charts

#!/bin/sh -e

app_version=$(cat ${IMAGE_INPUT}/tag)

echo "updating appVersion..."

yq eval ".appVersion = \"${app_version}\"" -i ${CHART_FILE}

echo "getting current chart version..."
current_version=$(yq eval ".version" ${CHART_FILE})

echo "updating chart version"
new_chart_version=$(concourse-pipelines-repo/common/scripts/bump_semver.sh ${current_version} patch)
yq eval ".version = \"${new_chart_version}\"" -i ${CHART_FILE}

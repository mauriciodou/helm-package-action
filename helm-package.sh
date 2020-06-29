#!/bin/bash
TARGET=$1
HELM_REPO=$2

set -euo pipefail

if [[ -z "$TARGET" ]]; then
	echo "Set a target eg './stable', '*', './stable/ambassador'"
	exit 1
fi

if [[ -z "$HELM_REPO" ]]; then
	echo "No repository specified to publish the chart"
	exit 1
fi

if [[ -f "$TARGET/Chart.yaml" ]]; then
	chart=$(basename "$TARGET")
	echo "Packaging $chart from $TARGET"
	# helm package "$TARGET"

	if helm plugin list | awk '{print $1}' | grep -q push; then
		helm plugin remove push
		helm plugin install https://github.com/chartmuseum/helm-push.git
	else
		helm plugin install https://github.com/chartmuseum/helm-push.git
	fi
	
	helm push $TARGET/ --force $HELM_REPO --username=$HELM_USER --password=$HELM_PASSWORD --insecure
fi

exit 0

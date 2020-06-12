#!/bin/bash
SVC_ACCOUNT=SVCKPSDOCKP
TARGET=$1

set -euo pipefail

if [[ -z "$TARGET" ]]; then
	echo "Set a target eg './stable', '*', './stable/ambassador'"
	exit 1
fi

if [[ -f "$TARGET/Chart.yaml" ]]; then
	chart=$(basename "$TARGET")
	echo "Packaging $chart from $TARGET"
	helm package "$TARGET"
fi

# Publish
REPO=$2
if [[ -z "$REPO" ]]; then
	echo "No repository specified to publish the chart"
	exit 1
fi

chart=$(basename "$TARGET")
echo "Publishing $chart from $TARGET"

for package in $GITHUB_WORKSPACE/*.tgz; do curl --insecure -u$SVC_ACCOUNT:$SVC_ACCOUNT_PASSWORD -T $package $REPO/$(basename $package); done

exit 0

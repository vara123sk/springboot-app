#!/bin/bash
set -euo pipefail
echo "Running Black Duck Detect..."
# This script expects BD_URL and BD_TOKEN as env vars (or Jenkins credentials)
if [ -z "${BLACKDUCK_URL:-}" ] || [ -z "${BLACKDUCK_API_TOKEN:-}" ]; then
  echo "BLACKDUCK_URL or BLACKDUCK_API_TOKEN not set - exiting"
  exit 1
fi
bash <(curl -s https://detect.synopsys.com/detect.sh) \\
  --blackduck.url="$BLACKDUCK_URL" \\
  --blackduck.api.token="$BLACKDUCK_API_TOKEN" \\
  --detect.project.name="sample-springboot-app" \\
  --detect.project.version.name="${BUILD_NUMBER:-local}"

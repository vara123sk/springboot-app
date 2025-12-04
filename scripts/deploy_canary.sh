#!/bin/bash
set -euo pipefail
BUILD_NUMBER=${1:-local}
echo "Starting canary deployment for build $BUILD_NUMBER"

# Create a canary deployment with fewer replicas and traffic weight
helm upgrade --install sample-app-canary ./helm \\
  --set image.tag=${BUILD_NUMBER} \\
  --set canary.enabled=true \\
  --set canary.weight=10

echo "Canary deployment applied. Monitor metrics and promote when ready."

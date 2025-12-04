#!/bin/bash
set -euo pipefail
BUILD_NUMBER=${1:-local}
echo "Starting blue-green deployment for build $BUILD_NUMBER"

# Detect current active color via service selector
ACTIVE=$(kubectl get svc sample-service -o jsonpath='{.spec.selector.color}' 2>/dev/null || echo "none")
if [ "$ACTIVE" == "blue" ]; then
  NEW="green"
else
  NEW="blue"
fi

echo "Active color: $ACTIVE -> New color: $NEW"

# Use helm to upgrade with the new image tag and color
helm upgrade --install sample-app ./helm \\
  --set image.tag=${BUILD_NUMBER} \\
  --set color=${NEW}

# Wait for deployment rollout
kubectl rollout status deployment/sample-app-${NEW} --timeout=120s

# Switch service selector to new color
kubectl patch svc sample-service -p '{"spec":{"selector":{"app":"sample-app","color":"'${NEW}'"}}}'

echo "Blue-Green deployment complete - active color is now $NEW"

#!/bin/bash
set -euo pipefail
echo "Running Sonar scanner..."
# Assumes Jenkins SonarQube environment variables are set when called from Jenkins
mvn sonar:sonar -Dsonar.projectKey=sample-springboot-app

# Spring Boot DevSecOps Project

This project is a complete starter template that demonstrates a DevSecOps pipeline for a Spring Boot application.
It includes:

- Spring Boot application (minimal)
- Unit test (JUnit 5)
- Maven pom with JaCoCo
- Dockerfile
- Jenkinsfile (Declarative) with stages: Test, Sonar, Black Duck, Veracode, Docker build/push, Blue-Green & Canary deploy
- Scripts for Sonar, Black Duck, Veracode, Docker build, Blue-Green and Canary deploys
- Helm chart with blue/green color switching and canary example
- k8s sample canary manifest
- .gitignore

## Quick local build
1. Build the project: `mvn -B -DskipTests package`
2. Build docker image: `docker build -t sample-springboot-app:local .`
3. Run locally: `docker run -p 8080:8080 sample-springboot-app:local`
   then visit http://localhost:8080/api/hello

## Jenkins
- Create credentials: docker-hub-credentials (username/password), blackduck-token, veracode-id, veracode-key
- Configure SonarQube in Jenkins (name: sonar-server)
- Pipeline job (multibranch or pipeline) pointing at this repository
- Ensure Jenkins agent has docker, kubectl, helm, and maven installed (or use dedicated tools)

## Helm & Kubernetes
- `helm upgrade --install sample-app ./helm --set image.tag=<build-number> --set color=green`
- Service `sample-service` selects pods by color label to perform blue/green switch
- Canary: use `k8s/sample-canary.yaml` as a simple example OR enable canary values in Helm and customize ingress/traffic weights via your service mesh.

## Notes / Next steps
- Replace placeholder credentials and tool-specific code with your organization's integration details
- Harden Dockerfile (non-root user), add multi-stage build if you have native build steps
- Add Prometheus/Grafana and alerting for rollout verification
- Integrate pipeline gating (manual approval) for production promotion.

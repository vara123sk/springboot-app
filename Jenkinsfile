pipeline {
  agent any

  environment {
    REGISTRY = "vara123sk/springboot-app"
    SONAR = 'sonar-server'             // Jenkins SonarQube server name
    BD_TOKEN = credentials('blackduck-token')
    VERACODE_ID = credentials('veracode-id')
    VERACODE_KEY = credentials('veracode-key')
  }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '30'))
    ansiColor('xterm'){
                    sh 'echo "Building..."'
                }
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Maven Build & Unit Tests') {
      steps {
        sh 'mvn clean test -B'
      }
      post {
        always {
          junit '**/target/surefire-reports/*.xml'
          sh 'mvn jacoco:report || true'
          archiveArtifacts allowEmptyArchive: true, artifacts: 'target/*.jar'
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${SONAR}") {
          sh 'mvn sonar:sonar -Dsonar.projectKey=sample-springboot-app -Dsonar.host.url=$SONAR_HOST_URL'
        }
      }
    }

    stage('Black Duck SCA') {
      steps {
        sh 'bash scripts/blackduck_scan.sh'
      }
    }

    stage('Veracode Upload') {
      steps {
        sh 'bash scripts/veracode_upload.sh'
      }
    }

    stage('Package') {
      steps {
        sh 'mvn -DskipTests package -B'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }

    stage('Build & Push Docker') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            def img = docker.build("${REGISTRY}:${env.BUILD_NUMBER}")
            img.push()
            sh "docker image rm ${REGISTRY}:${env.BUILD_NUMBER} || true"
          }
        }
      }
    }

    stage('Deploy (Blue-Green)') {
      when { branch 'main' }
      steps {
        sh 'bash scripts/deploy_blue_green.sh ${BUILD_NUMBER}'
      }
    }

    stage('Canary Release') {
      when { branch 'main' }
      steps {
        sh 'bash scripts/deploy_canary.sh ${BUILD_NUMBER}'
      }
    }
  }

  post {
    success {
      echo 'Pipeline succeeded.'
    }
    failure {
      echo 'Pipeline failed.'
      mail to: 'dev-team@example.com',
           subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
           body: "See Jenkins console output at ${env.BUILD_URL}"
    }
    always {
      cleanWs()
    }
  }
}

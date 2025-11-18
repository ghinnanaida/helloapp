pipeline {
  agent any

  environment {
    APP = "HelloWorld4"
    APP_DIR = "helloworldapp"
    VERSION = "1.0.1"
    RID = "linux-x64"     // change to linux-arm64 for Pi job/branch
    ARCH = "amd64"        // change to arm64 for raspi 
    OUTDIR = "out"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build using Dockerfile') {
            steps {
                sh '''
                docker build -t helloapp-builder .
                docker run --name builder-container helloapp-builder
                docker cp builder-container:/app/out ./out
                docker rm builder-container
                '''
            }
        }
  }

  post {
    success { 
        echo "Build ${APP}_${VERSION}_${ARCH}.deb completed" 
        archiveArtifacts artifacts: '**/*.deb'}
    failure { echo "Build failed" }
  }
}
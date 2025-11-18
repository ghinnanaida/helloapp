pipeline {
  agent any

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
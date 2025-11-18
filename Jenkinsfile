pipeline {
  agent any

  environment {
    APP = "HelloWorld4"
    APP_DIR = "helloworldapp"
    VERSION = "1.0.0"
    RID = "linux-x64"     // change to linux-arm64 for Pi job/branch
    ARCH = "amd64"        // change to arm64 for Pi
    OUTDIR = "out"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build .deb') {
      steps {
        sh """
          chmod +x jenkins/build-deb.sh
          APP=${APP} APP_DIR=${APP_DIR} VER=${VERSION} RID=${RID} ARCH=${ARCH} OUTDIR=${OUTDIR} \
            ./jenkins/build-deb.sh
        """
      }
      post {
        success {
          archiveArtifacts artifacts: "${OUTDIR}/*.deb", fingerprint: true
        }
      }
    }

    // stage('Publish to HTTP repo (optional)') {
    //   when { expression { return fileExists('/var/www/html/repo') } } // only if you have a repo folder
    //   steps {
    //     sh """
    //       sudo mkdir -p /var/www/html/repo
    //       sudo cp ${OUTDIR}/${APP}_${VERSION}_${ARCH}.deb /var/www/html/repo/
    //       sudo chown www-data:www-data /var/www/html/repo/${APP}_${VERSION}_${ARCH}.deb || true
    //       # optional: keep a stable latest name
    //       sudo cp /var/www/html/repo/${APP}_${VERSION}_${ARCH}.deb /var/www/html/repo/${APP}_latest_${ARCH}.deb
    //     """
    //   }
    // }
  }

  post {
    success { echo "Build ${APP}_${VERSION}_${ARCH}.deb completed" }
    failure { echo "Build failed" }
  }
}
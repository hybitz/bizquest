pipeline {
  agent none
  environment {
    APP_NAME = 'bizquest'
    KANIKO_OPTIONS = "--cache=${CACHE} --compressed-caching=false --build-arg registry=${ECR}"
  }
  stages {
    stage('build') {
      agent { kubernetes { inheritFrom 'kaniko' } }
      steps {
        container('kaniko') {
          ansiColor('xterm') {
            sh '/kaniko/executor -f `pwd`/Dockerfile.base -c `pwd` -d=${ECR}/${APP_NAME}/base:latest ${KANIKO_OPTIONS}'
            sh '/kaniko/executor -f `pwd`/Dockerfile.test -c `pwd` -d=${ECR}/${APP_NAME}/test:latest ${KANIKO_OPTIONS}'
          }
        }
      }
    }
    stage('unit') {
      agent {
        kubernetes {
          yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    image: ${ECR}/${APP_NAME}/test:latest
    imagePullPolicy: Always
    command:
    - cat
    tty: true
"""
        }
      }
      environment {
        COVERAGE = 'true'
        DISABLE_SPRING = 'true'
        FORMAT = 'junit'
        RAILS_ENV = 'test'
      }
      steps {
        container('app') {
          ansiColor('xterm') {
            sh "bundle exec rails db:reset"
            sh "bundle exec rails test"
          }
        }
      }
    }
    stage('release') {
      agent { kubernetes { inheritFrom 'kaniko' } }
      environment {
        RELEASE_TAG = "v0.0.1-${BUILD_NUMBER}"
      }
      stages {
        stage('tagging') {
          steps {
            container('jnlp') {
              sshagent(credentials: [env.GITHUB_SSH_KEY]) {
                sh "git push origin HEAD:release"
                sh "git tag ${RELEASE_TAG}"
                sh "git push origin ${RELEASE_TAG}"
              }
            }
          }
        }
        stage('artifact') {
          steps {
            container('kaniko') {
              ansiColor('xterm') {
                sh '/kaniko/executor -f `pwd`/Dockerfile.app -c `pwd` -d=${ECR}/${APP_NAME}/app:${RELEASE_TAG} ${KANIKO_OPTIONS}'
              }
            }
          }
        }
      }
    }
  }
}

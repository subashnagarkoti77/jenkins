pipeline {
    agent any

    environment {
        dockerImage="subash/mavenapp"
    }
    stages {
        stage('Building the maven app') {
            agent {
                    label 'ubuntu-slave-node'
                }
            steps {
               sh 'mvn -f pom.xml clean package'
            }
            post {
                success {
                echo "Build complete and now archiving artifacts"
                archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }
        stage('Docker image build'){
                    agent {
                      label 'ubuntu-slave-node'
                   }
                    steps{
                      copyArtifacts filter: '**/*.war', fingerprintArtifacts: true, projectName: env.JOB_NAME, selector: specific(env.BUILD_NUMBER)
                      echo "building docker image"
                      sh 'whoami'
                      sh 'docker build -t $dockerImage:$BUILD_NUMBER .'
                    }
        }
        stage('DeploytoDevenv') {
            steps {
                echo 'depolying the dev env'
            }
        }
        stage('DeploytoProduction') {
            steps {
                echo 'Deploying to production env'
            }
        }
    }
}


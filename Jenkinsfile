pipeline {
    agent any

    environment {
        dockerImage= "subashn77/mavenapp"
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
        stage('Push Image'){
                  agent {
                    label 'ubuntu-slave-node'
                  }
                    steps {
                        withDockerRegistry([credentialsId: 'dockerhubcredentials', url: '']) {
                            sh '''
                            docker push $dockerImage:$BUILD_NUMBER
                            '''
                        }
                    }
        }
        stage('Deploy to Development Env') {
                    agent {
                        label 'ubuntu-slave-node'
                    }
                    steps {
                        echo "Running app on development env"
                        sh '''
                        docker stop subashtryjenkins || true
                        docker rm subashtryjenkins || true
                        docker run -itd --name subashtryjenkins -p 8082:8080 $dockerImage:$BUILD_NUMBER
                        sh '''
                    }
        }
        stage('Deploy to Production Env') {
                    agent {
                        label 'ubuntu-slave-node'
                    }
                    steps {
                        timeout(time:5, unit:'MINUTES'){
                        input message:'Approve PRODUCTION Deployment?'
                        }
                        echo "Running app on Prod env"
                        sh '''
                        docker stop subashtryjenkins || true
                        docker rm subashtryjenkins || true
                        docker run -itd --name subashtryjenkins -p 8083:8080 $dockerImage:$BUILD_NUMBER
                        '''
                    }
        }
         post{
                always {
                    mail to: 'subnag77@gmail.com',
                    subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) status",
                    body: "Please go to ${BUILD_URL} and verify the build"
                }

                success {
                    mail bcc: '', body: """Hi Team,
                    Build #$BUILD_NUMBER is successful, please go through the url
                    $BUILD_URL
                    and verify the details.
                    Regards,
                    DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'subnag77@gmail.com'
                }

                failure {
                        mail bcc: '', body: """Hi Team,
                        Build #$BUILD_NUMBER is unsuccessful, please go through the url
                        $BUILD_URL
                        and verify the details.
                        Regards,
                        DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'subnag77@gmail.com'
                }
         }
    }
}

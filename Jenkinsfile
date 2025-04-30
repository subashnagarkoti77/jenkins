pipeline {
    agent any

    stages {
        stage('BUILD') {
            steps {
                echo 'building the code'
            }
        }
        stage('UNIT-TEST') {
            steps {
                echo 'Running the unit test'
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


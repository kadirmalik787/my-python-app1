pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDS = credentials('docker-hub-creds')  // Jenkins credentials ID
        IMAGE_NAME = "kadirmalik457/my-web-app"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/kadirmalik787/my-python-app1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Docker Login') {
            steps {
                sh "echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker logout'
        }
    }
}


pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = "kadirmalik457/my-web-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                git 'https://github.com/kadirmalik787/my-python-app1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_CREDS_PSW | docker login -u $DOCKER_HUB_CREDS_USR --password-stdin"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker push $IMAGE_NAME'
                }
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


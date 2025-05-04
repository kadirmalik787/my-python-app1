pipeline {
    agent any

    environment {
        DOCKER_HUB = credentials('docker-hub-creds')
        IMAGE_NAME = "kadirmalik457/my-python-app1:latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/kadirmalik787/my-python-app1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME -f Dockerfile .'
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin"
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

pipeline {
    agent any

    environment {
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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
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



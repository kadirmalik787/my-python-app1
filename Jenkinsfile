pipeline {
    agent any

    environment {
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

        stage('Docker Login & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_HUB_USR', passwordVariable: 'DOCKER_HUB_PSW')]) {
                        sh """
                            echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin
                            docker push $IMAGE_NAME
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker logout || true'
        }
    }
}

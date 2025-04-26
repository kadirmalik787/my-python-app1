pipeline {
    agent any
    
    environment {
        DOCKER_HUB = credentials('docker-hub-creds')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/kadirmalik787/my-python-app1.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_USR}/my-python-app:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_HUB}") {
                        docker.image("${DOCKER_HUB_USR}/my-python-app:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        
        stage('Update K8s Manifest') {
            steps {
                sh """
                sed -i 's|image:.*|image: ${DOCKER_HUB_USR}/my-python-app:${env.BUILD_ID}|g' k8s/deployment.yaml
                git config user.email "jenkins@example.com"
                git config user.name "Jenkins"
                git add k8s/deployment.yaml
                git commit -m "Update image to version ${env.BUILD_ID}"
                git push https://${GITHUB_TOKEN}@github.com/kadirmalik787/my-python-app1.git
                """
            }
        }
    }
}

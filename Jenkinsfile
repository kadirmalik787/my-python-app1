pipeline {
    agent any
    
    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        GITHUB_CREDS = credentials('github-token')
        IMAGE_NAME = "${env.DOCKER_CREDS_USR}/my-python-app"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                script {
                    env.GIT_SHORT_HASH = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                    env.IMAGE_TAG = "${env.BUILD_ID}-${env.GIT_SHORT_HASH}"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    retry(3) {
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                            timeout(time: 5, unit: 'MINUTES') {
                                docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                            }
                        }
                    }
                }
            }
        }
        
        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    sh """
                    sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml
                    git config user.email "jenkins@example.com"
                    git config user.name "Jenkins"
                    git add k8s/deployment.yaml
                    git commit -m "CI: Update image to ${IMAGE_TAG}"
                    git push https://${GITHUB_CREDS}@github.com/kadirmalik787/my-python-app1.git HEAD:main
                    """
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                }
            }
        }
    }
    
    post {
        failure {
            echo "Pipeline failed - please check logs"
            // Add notification here if needed
        }
        success {
            echo "Pipeline succeeded!"
            echo "Deployed image: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}

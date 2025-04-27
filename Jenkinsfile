pipeline {
    agent any
    
    environment {
        // Docker Hub credentials (set these in Jenkins credentials store)
        DOCKER_CREDS = credentials('docker-hub-creds')
        // GitHub token (set this in Jenkins credentials store)
        GITHUB_CREDS = credentials('github-token')
        // Image name and tag
        IMAGE_NAME = "${env.DOCKER_CREDS_USR}/my-python-app"
        IMAGE_TAG = "${env.BUILD_ID}-${GIT_SHORT_HASH}"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                script {
                    // Get short git commit hash
                    GIT_SHORT_HASH = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        // Also tag as latest and push
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").tag('latest')
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }
        
        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    // Update deployment.yaml with new image
                    sh """
                    sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml
                    """
                    
                    // Commit and push changes
                    withCredentials([usernamePassword(
                        credentialsId: 'github-token',
                        usernameVariable: 'GIT_USERNAME',
                        passwordVariable: 'GIT_TOKEN'
                    )]) {
                        sh """
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins"
                        git add k8s/deployment.yaml
                        git commit -m "CI: Update image to ${IMAGE_TAG}"
                        git push https://${GIT_TOKEN}@github.com/kadirmalik787/my-python-app1.git HEAD:main
                        """
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Assuming kubectl is configured on Jenkins agent
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline completed successfully!"
            echo "Docker Image: ${IMAGE_NAME}:${IMAGE_TAG}"
            echo "Deployed to Kubernetes cluster"
        }
        failure {
            echo "Pipeline failed - please check logs"
            // You can add notification steps here (email, Slack, etc.)
        }
    }
}

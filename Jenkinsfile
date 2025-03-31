pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "anooplivfree/taskmanagement-app"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning the repository..."
                git branch: '{master/main}', url: '{Your-gitrepo-link}'
            }
        }

        stage('Build Maven Project') {
            steps {
                echo "Building the Spring Boot application..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Deploying the application using Docker Compose..."
                sh '''
                    docker compose down || true
                    docker compose up -d --build
                '''
            }
        }

        stage('Verify Services') {
            steps {
                echo "Verifying running services..."
                sh 'docker compose ps'
            }
        }

        stage('Cleanup Workspace') {
            steps {
                echo "Cleaning up the workspace..."
                sh 'rm -rf *'
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}

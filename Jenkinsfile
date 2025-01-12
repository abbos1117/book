pipeline {
    environment {
        gitRepo = 'https://github.com/abbos1117/book.git'  // GitHub repository URL
        branchName = 'main'  // Git branch name
        VIRTUAL_ENV = '.venv'  // Virtual environment name
    }

    agent any

    stages {
        stage('Git - Checkout') {
            steps {
                echo "Cloning repository..."
                checkout([$class: 'GitSCM', branches: [[name: branchName]], userRemoteConfigs: [[url: gitRepo]]])
            }
        }

        stage('Set Up Virtual Environment') {
            steps {
                script {
                    echo "Setting up the virtual environment..."

                    // Install dependencies using Pipenv or other tools as per your setup
                    sh '''
                        python3 -m venv ${VIRTUAL_ENV}
                        . ${VIRTUAL_ENV}/bin/activate
                        pip install -r requirements.txt
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running Django tests..."

                    // Activate virtual environment and run Django tests
                    sh '''
                        . ${VIRTUAL_ENV}/bin/activate
                        python manage.py test myapp.tests
                    '''
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    echo "Cleaning up..."

                    // Deactivate virtual environment and remove it
                    sh '''
                        deactivate || true
                        rm -rf ${VIRTUAL_ENV}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Build and test completed successfully!"
        }
        failure {
            echo "Build or test failed!"
        }
        always {
            echo "Workspace cleaning up..."
            cleanWs()  // Clean workspace after the job
        }
    }
}

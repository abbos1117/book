pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        stage('Set Up Virtual Environment') {
            steps {
                script {
                    echo 'Setting up the virtual environment...'
                    // Install pipenv to handle dependencies
                    sh 'pip install pipenv'
                    // Install dependencies using pipenv
                    sh 'pipenv install --dev'
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running tests...'
                    // Run the Django tests using pipenv
                    sh 'pipenv run python manage.py test myapp.tests'
                }
            }
        }
        stage('Clean Up') {
            steps {
                echo 'Cleaning up workspace...'
                cleanWs()
            }
        }
    }

    post {
        always {
            echo 'Cleaning up the workspace...'
            cleanWs()
        }
        success {
            echo 'Build and tests passed successfully.'
        }
        failure {
            echo 'Build or tests failed!'
        }
    }
}

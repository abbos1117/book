pipeline {
    agent any

    environment {
        VIRTUAL_ENV = "${WORKSPACE}/venv"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Set Up Virtual Environment') {
            steps {
                script {
                    // Agar virtual muhit mavjud bo'lmasa, uni yaratamiz
                    if (!fileExists("${env.VIRTUAL_ENV}")) {
                        sh "python3 -m venv ${env.VIRTUAL_ENV}"
                    }
                    // Virtual muhitni faollashtiramiz
                    sh ". ${env.VIRTUAL_ENV}/bin/activate"
                    // requirements.txt faylini o'rnatamiz
                    sh "pip install -r requirements.txt"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Testlarni bajarish
                    sh ". ${env.VIRTUAL_ENV}/bin/activate && python manage.py test myapp.tests"
                }
            }
        }

        stage('Clean Up') {
            steps {
                cleanWs()
            }
        }
    }

    post {
        always {
            // Testdan keyin virtual muhiti tozalash
            sh "deactivate || true"
        }
    }
}

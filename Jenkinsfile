pipeline {
    agent any

    environment {
        // Virtual muhitni yaratish uchun Python versiyasini belgilash
        VENV_PATH = ".venv"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Repositoryni olish...'
                // Git repozitoriyasini olish
                checkout scm
            }
        }
        
        stage('Set Up Python Virtual Environment') {
            steps {
                echo 'Python virtual muhitini yaratish...'
                script {
                    // Agar virtual muhit mavjud bo'lmasa, uni yaratish
                    if (!fileExists(VENV_PATH)) {
                        sh 'python3 -m venv .venv' // Virtual muhit yaratish
                    }
                    // Virtual muhitni faollashtirish
                    sh '. .venv/bin/activate'
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Kerakli kutubxonalarni o\'rnatish...'
                script {
                    // virtual muhitda kerakli paketlarni o'rnatish
                    sh '. .venv/bin/activate && pip install -r requirements.txt'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Testlarni ishga tushurish...'
                script {
                    // Django testlarni ishga tushirish
                    sh '. .venv/bin/activate && python manage.py test myapp.tests'
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                echo 'Ishlashni yakunlash va virtual muhitni o\'chirish...'
                script {
                    // Virtual muhitni o'chirish
                    sh 'rm -rf .venv'
                }
            }
        }
    }
}

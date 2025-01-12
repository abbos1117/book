pipeline {
    environment {
        gitRepo = 'https://github.com/abbos1117/book.git' // GitHub repository manzili
        branchName = 'main' // Git branch nomi
        dockerImage = '' // Docker image uchun o'zgaruvchi
    }

    agent any

    stages {
        stage('Git - Checkout') {
            steps {
                echo "Repositoryni klonlash..."
                checkout([$class: 'GitSCM', branches: [[name: branchName]], userRemoteConfigs: [[url: gitRepo]]])
            }
        }

        stage('Docker Image Yaratish') {
            steps {
                script {
                    echo "Docker image yaratilyapti..."
                    dockerImage = docker.build("${env.DOCKER_USERNAME}/book_container:${env.BUILD_NUMBER}") // Build raqami bilan Docker image yaratish
                    dockerImage.tag("latest") // 'latest' tegini qo‘shish
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Testlarni ishga tushirish..."
                    sh 'docker run --rm ${env.DOCKER_USERNAME}/book_container:${env.BUILD_NUMBER} pipenv run python manage.py test myapp.tests'
                }
            }
        }

        stage('Docker Image-ni Push Qilish') {
            steps {
                script {
                    echo "Docker Hub'ga autentifikatsiya qilinyapti..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin' // Docker Hub'ga login
                    }

                    echo "Docker image Docker Hub'ga yuklanyapti..."
                    dockerImage.push("${env.BUILD_NUMBER}") // Build raqami bilan image push qilish
                    dockerImage.push("latest") // 'latest' teg bilan image push qilish
                }
            }
        }

        stage('Docker Image-ni Ishga Tushirish') {
            steps {
                script {
                    echo "Docker image ishga tushirilmoqda..."
                    // Yangi konteyner nomi bilan Docker containerni ishga tushirish
                    sh "docker run -d -p 7002:7000 --name book-container1 ${env.DOCKER_USERNAME}/book_container:${env.BUILD_NUMBER}"
                    echo "Docker image 'book-container1' konteynerida ishlamoqda"
                }
            }
        }

        stage('Tozalash') {
            steps {
                script {
                    echo "Docker image va konteynerlarni tozalash..."
                    sh "docker rmi ${env.DOCKER_USERNAME}/book_container:${env.BUILD_NUMBER} || true" // Build image-ni o'chirish
                    sh "docker rmi ${env.DOCKER_USERNAME}/book_container:latest || true" // 'latest' image-ni o'chirish
                    sh "docker stop book-container1 || true" // Yangi konteynerni to'xtatish
                    sh "docker rm book-container1 || true" // Yangi konteynerni o'chirish
                }
            }
        }
    }

    post {
        success {
            echo "Build, test va push muvaffaqiyatli yakunlandi!"
        }
        failure {
            echo "Build yoki test muvaffaqiyatsiz tugadi!"
        }
        always {
            echo "Workspace tozalanmoqda..."
            cleanWs() // Workspace tozalash
        }
    }
}

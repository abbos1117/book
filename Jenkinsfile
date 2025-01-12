pipeline {
    environment {
        gitRepo = 'https://github.com/abbos1117/book.git' // GitHub repository manzili
        branchName = 'main' // Git branch nomi
        dockerImage = '' // Docker image uchun o'zgaruvchi
        VIRTUAL_ENV = '.venv' // Virtual muhit nomi
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

            // Docker konteyneri ichida testlarni ishga tushirish
            sh '''
                docker run -d -p 7002:7000 --name book-container1 ${env.DOCKER_USERNAME}/book_container:${env.BUILD_NUMBER}
                echo "Docker konteyneri ishga tushirildi. Testlar ishga tushadi..."
                
                # Docker konteynerida testlarni bajarish
                docker exec book-container1 /bin/bash -c "
                    python3 -m venv ${VIRTUAL_ENV} &&
                    . ${VIRTUAL_ENV}/bin/activate &&
                    pip install -r /app/requirements.txt &&
                    python manage.py test myapp.tests"
            '''
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
                    dockerImage.push("${BUILD_NUMBER}") // Build raqami bilan image push qilish
                    dockerImage.push("latest") // 'latest' teg bilan image push qilish
                }
            }
        }

        stage('Docker Image-ni Ishga Tushirish') {
            steps {
                script {
                    echo "Docker image ishga tushirilmoqda..."
                    // Yangi konteyner nomi bilan Docker containerni ishga tushirish
                    sh "docker run -d -p 7002:7000 --name book-container1 ${DOCKER_USERNAME}/book_container:${BUILD_NUMBER}"
                    echo "Docker image 'book-container1' konteynerida ishlamoqda"
                }
            }
        }

        stage('Tozalash') {
            steps {
                script {
                    echo "Docker image va konteynerlarni tozalash..."
                    sh "docker rmi ${DOCKER_USERNAME}/book_container:${BUILD_NUMBER} || true" // Build image-ni o'chirish
                    sh "docker rmi ${DOCKER_USERNAME}/book_container:latest || true" // 'latest' image-ni o'chirish
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

pipeline {
    environment {
        gitRepo = 'https://github.com/abbos1117/book.git'
        branchName = 'main'
        dockerImage = ''
        // Virtual muhit uchun yangi manzil
        VIRTUAL_ENV = "${WORKSPACE}/env"  // Yangi nom, WORKSPACE ichida 'env' deb nomladi
        dockerhub_user = "${dockerhub_name}"
        dockerhub_pass = "${dockerhub_pass}"
        // Yangi konteyner nomi
        containerName = "kutubxona-container-${env.BUILD_NUMBER}" // Yangi nomda konteyner yaratish
    }

    agent any

    stages {
        stage('Git - Checkout') {
            steps {
                echo "Repositoryni klonlash..."
                checkout([$class: 'GitSCM', branches: [[name: branchName]], userRemoteConfigs: [[url: gitRepo]]])
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
                    sh ". ${env.VIRTUAL_ENV}/bin/activate && python3 manage.py test myapp.tests"
                }
            }
        }

        stage('Docker Image Yaratish') {
            steps {
                script {
                    echo "Docker image yaratilyapti..."
                    dockerImage = docker.build("${env.dockerhub_user}/book_container:${env.BUILD_NUMBER}")
                    dockerImage.tag("latest")
                }
            }
        }

        stage('Docker Image-ni Push Qilish') {
            steps {
                script {
                    echo "Docker Hub'ga autentifikatsiya qilinyapti..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_id', usernameVariable: 'dockerhub_user', passwordVariable: 'dockerhub_pass')]) {
                        sh 'echo "$dockerhub_pass" | docker login -u "$dockerhub_user" --password-stdin'
                    }

                    echo "Docker image Docker Hub'ga yuklanyapti..."
                    dockerImage.push("${env.BUILD_NUMBER}")
                    dockerImage.push("latest")
                }
            }
        }

        stage('Docker Image-ni Ishga Tushirish') {
            steps {
                script {
                    echo "Eski konteynerni to'xtatish va o'chirish..."
                    sh "docker stop ${env.containerName} || true"
                    sh "docker rm ${env.containerName} || true"
                    echo "Docker image ishga tushirilmoqda..."
                    sh "docker run -d -p 7005:7005 --name ${env.containerName} ${env.dockerhub_user}/book_container:${env.BUILD_NUMBER}"
                    echo "Docker image '${env.containerName}' konteynerida ishlamoqda"
                }
            }
        }

        stage('Tozalash') {
            steps {
                script {
                    echo "Docker image va konteynerlarni tozalash..."
                    sh "docker rmi ${env.dockerhub_user}/book_container:${env.BUILD_NUMBER} || true"
                    sh "docker rmi ${env.dockerhub_user}/book_container:latest || true"
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
            cleanWs()
        }
    }
}

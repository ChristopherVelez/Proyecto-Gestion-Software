pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ChristopherVelez/Proyecto-Gestion-Software.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Deploy (Local)') {
            steps {
                echo 'Desplegando aplicación en entorno local...'
                sh 'mkdir -p deploy'
                sh 'cp target/*.jar deploy/'
                echo 'Deploy realizado en carpeta /deploy (entorno de prueba)'
            }
        }
    }

    post {
        success {
            echo "Pipeline completado correctamente."
        }
        failure {
            echo "Pipeline falló."
        }
        always {
            echo "Pipeline finalizado."
        }
    }
}

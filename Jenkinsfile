pipeline {
    agent any

    tools {
        maven 'M3'
    }

    stages {

        stage('Build') {
            steps {
                echo 'Iniciando compilación...'
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Ejecutando pruebas unitarias...'
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
                echo 'Empaquetando artefacto...'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Deploy (Local)') {
            steps {
                echo 'Desplegando aplicación en entorno de prueba local...'
                sh 'mkdir -p deploy'
                sh 'cp target/*.jar deploy/'
                echo 'Despliegue completado en la carpeta /deploy.'
            }
        }
    }

    post {
        success {
            emailext(
                to: 'waltduchi@gmail.com',
                subject: "Build EXITOSO: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "El build se completó correctamente.\nURL: ${env.BUILD_URL}",
                from: 'waltduchi@gmail.com',
                smtpUsername: 'waltduchi@gmail.com',
                smtpPassword: credentials('gmail-app-password')
            )
        }   
        failure {
            emailext(
                to: 'waltduchi@gmail.com',
                subject: "Build FALLIDO: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "El build ha fallado.\nURL: ${env.BUILD_URL}",
                from: 'waltduchi@gmail.com',
                smtpUsername: 'waltduchi@gmail.com',
                smtpPassword: credentials('gmail-app-password')
            )
        }
    }
}

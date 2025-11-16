// Reemplaza 'M3' por el nombre que le diste a tu configuración de Maven en Jenkins
@Library('jenkins-pipeline-shared-libraries') _

pipeline {
    agent any
    
    // Agregamos la configuración de Maven (asumiendo que se llama 'M3' en Global Tool Config)
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
                    // Publica los resultados JUnit para la evidencia
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
                // Crea la carpeta y mueve el JAR
                sh 'mkdir -p deploy'
                sh 'cp target/*.jar deploy/'
                echo 'Despliegue completado en la carpeta /deploy.'
            }
        }
    }

    post {
        // Ejecución de Notificaciones (Requiere configuración de Email en Jenkins)
        success {
            echo "Pipeline completado correctamente. Enviando notificación."
            mail(
                to: 'TU_EMAIL_DE_PRUEBA@dominio.com',
                subject: "✅ ÉXITO: Pipeline ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: "El proceso CI/CD fue exitoso. Artefacto desplegado. Revisar: ${env.BUILD_URL}"
            )
        }
        failure {
            echo "Pipeline falló. Enviando alerta."
            mail(
                to: 'TU_EMAIL_DE_PRUEBA@dominio.com',
                subject: "❌ FALLO: Pipeline ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: "El pipeline falló. Por favor, revisa la etapa ${env.STAGE_NAME} en: ${env.BUILD_URL}"
            )
        }
        always {
            echo "Pipeline finalizado."
        }
    }
}


Con este `Jenkinsfile` modificado, tu proyecto cumple con: **Build**, **Test** (con evidencia), **Deploy** (local) y **Notificaciones**.

Recuerda reemplazar `TU_EMAIL_DE_PRUEBA@dominio.com` con un email funcional y asegurarte de que Jenkins tiene acceso al servidor de correo. Una vez que esto funcione, el único paso pendiente será la **Documentación (Informe Técnico)**.

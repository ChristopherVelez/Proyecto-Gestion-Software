// Jenkinsfile (Pipeline Declarativo)

pipeline {
    // 1. Configuración del Agente (Usamos Docker con JDK 24 para estandarizar el ambiente)
    agent {
    docker {
        // Imagen de Maven con JDK 21 para compilar y probar
        image 'maven:3-openjdk-21' // ¡CORREGIDO!
        // Caché local de Maven para descargas más rápidas
        args '-v /root/.m2:/root/.m2' 
    }
}

    // 2. Definición de las Etapas del Pipeline
    stages {
        // ETAPA 1: BUILD (Compilación y Empaquetado)
        stage('Build & Package') {
            steps {
                echo 'Iniciando la compilación y empaquetado del código (saltando pruebas).'
                sh 'mvn -B clean package -DskipTests'
            }
        }

        // ETAPA 2: TEST (Ejecución de pruebas unitarias)
        stage('Test') {
            steps {
                echo 'Ejecutando pruebas unitarias con JUnit...'
                sh 'mvn test'
            }
            // Archiva los resultados de las pruebas JUnit para visualización en Jenkins
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        // ETAPA 3: DEPLOY (Despliegue en entorno de prueba con Docker)
        stage('Deploy') {
            steps {
                echo 'Generando imagen Docker con JDK 24 y desplegando en entorno de prueba.'
                script {
                    // Crea la imagen usando el Dockerfile de la raíz
                    def dockerImage = docker.build("proyecto-gcs:${env.BUILD_NUMBER}")
                    
                    // Detiene y elimina cualquier contenedor previo con el mismo nombre para evitar conflictos
                    sh 'docker stop proyecto-gcs-running || true'
                    sh 'docker rm proyecto-gcs-running || true'
                    
                    // Despliega el contenedor en modo 'detached' (-d) y mapea el puerto 8080
                    dockerImage.run('-d -p 8080:8080 --name proyecto-gcs-running')
                    echo "Despliegue completado. Contenedor 'proyecto-gcs-running' corriendo en el puerto 8080."
                }
            }
        }
    }

    // 3. Post-Acciones Globales (Notificaciones y Archivo de Artefactos)
    post {
        // Siempre se ejecuta al final del pipeline
        always {
            echo 'Archivando artefactos generados (JAR/WAR)...'
            // ARCHIVAR ARTEFACTO: Guarda el JAR en Jenkins (para evidencia)
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }

        // Se ejecuta si TODAS las etapas anteriores fueron exitosas
        success {
            echo 'Pipeline CI/CD completado exitosamente. Enviando notificación.'
            // NOTIFICACIÓN DE ÉXITO: Implementación de envío de correo
            mail to: 'christopher.velezpul@ug.edu.ec', 
                 subject: "Éxito CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}", 
                 body: "El Pipeline CI/CD se ejecutó exitosamente. Revisa la consola: ${env.BUILD_URL}"
        }

        // Se ejecuta si CUALQUIER etapa anterior falló
        failure {
            echo 'Pipeline FALLÓ. Enviando notificación de error.'
            // NOTIFICACIÓN DE FALLO: Implementación de envío de correo
            mail to: 'christopher.velezpul@ug.edu.ec', // << AJUSTAR CORREO
                 subject: "FALLO CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}", 
                 body: "¡Alerta! El Pipeline CI/CD falló. Revisa los logs en: ${env.BUILD_URL}"
        }
    }
}

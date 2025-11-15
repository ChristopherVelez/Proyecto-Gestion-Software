// Jenkinsfile (Pipeline Declarativo)

pipeline {
    // Agente Principal: Usar el nodo base de Jenkins. 
    // Esto asegura que las etapas que lo necesiten (Deploy, Post-Actions) 
    // se ejecuten donde está el contexto del FilePath y el Docker Socket mapeado.
    agent any 

    // 2. Definición de las Etapas del Pipeline
    stages {
        
        // ETAPA 1: BUILD (Compilación y Empaquetado)
        stage('Build & Package') {
            // Agente local: Usar la imagen de Maven para obtener el comando 'mvn'.
            agent {
                docker {
                    image 'maven:latest'
                    args '-v /root/.m2:/root/.m2' // Caché de dependencias
                }
            }
            steps {
                echo 'Iniciando la compilación y empaquetado del código (saltando pruebas).'
                sh 'mvn -B clean package -DskipTests'
            }
        }

        // ETAPA 2: TEST (Ejecución de pruebas unitarias)
        stage('Test') {
            // Agente local: Usar la imagen de Maven.
            agent {
                docker {
                    image 'maven:latest'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo 'Ejecutando pruebas unitarias con JUnit...'
                sh 'mvn test'
            }
            post {
                always {
                    // El contexto FilePath está disponible dentro del contenedor Docker
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        // ETAPA 3: DEPLOY (Despliegue en entorno de prueba con Docker)
        stage('Deploy') {
            // NO se especifica agente aquí. Hereda 'agent any' y tiene acceso al Docker host.
            steps {
                echo 'Generando imagen Docker y desplegando en entorno de prueba.'
                
                // Usamos comandos SH directo, que acceden al host Docker daemon
                sh 'docker build -t proyecto-gcs-image:${env.BUILD_NUMBER} .'
                
                sh 'docker stop proyecto-gcs-running || true'
                sh 'docker rm proyecto-gcs-running || true'
                
                sh 'docker run -d -p 8080:8080 --name proyecto-gcs-running proyecto-gcs-image:${env.BUILD_NUMBER}'
                echo "Despliegue completado. Contenedor 'proyecto-gcs-running' corriendo en el puerto 8080."
            }
        }
    }

    // 3. Post-Acciones Globales (Notificaciones y Archivo de Artefactos)
    post {
        // ... (El resto del post-action se mantiene sin cambios)
        always {
            echo 'Archivando artefactos generados (JAR/WAR)...'
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }

        success {
            echo 'Pipeline CI/CD completado exitosamente. Enviando notificación.'
            mail to: 'christopher.velezpul@ug.edu.ec',
                 subject: "Éxito CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "El Pipeline CI/CD se ejecutó exitosamente. Revisa la consola: ${env.BUILD_URL}"
        }

        failure {
            echo 'Pipeline FALLÓ. Enviando notificación de error.'
            mail to: 'christopher.velezpul@ug.edu.ec',
                 subject: "FALLO CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "¡Alerta! El Pipeline CI/CD falló. Revisa los logs en: ${env.BUILD_URL}"
        }
    }
}

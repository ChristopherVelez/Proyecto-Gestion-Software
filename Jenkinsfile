// Jenkinsfile

pipeline {
    // El agente principal (any) solo se usará para el Checkout y las post-acciones
    agent any 

    environment {
        CONTAINER_NAME = "proyecto-ci-cd-running"
        ARTIFACT_FILE = "app-1.0-SNAPSHOT.jar"
        DOCKER_IMAGE = "proyecto-ci-cd:${env.BUILD_NUMBER}" 
    }

    stages {
        // ETAPA 1: Build (Compilación)
        stage('Build') { 
            // Usamos un agente Docker con Maven y JDK 21 (compatible con 24)
            agent {
                docker {
                    image 'maven:3.9.6-openjdk-21' // Imagen compatible con Maven 3.9 y JDK 24
                    args '-v $HOME/.m2:/root/.m2' // Caching de dependencias
                }
            }
            steps { 
                echo 'Iniciando compilación...' 
                // Los comandos mvn se ejecutan dentro del contenedor temporal de Maven
                sh 'mvn -B clean package -DskipTests' 
            } 
        }
        
        // ETAPA 2: Test (Pruebas Unitarias)
        stage('Test') { 
            // Reutiliza el mismo agente Docker
            agent {
                docker {
                    image 'maven:3.9.6-openjdk-21'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps { 
                echo 'Ejecutando pruebas...' 
                sh 'mvn test' 
                // Asegúrate de que los reportes se publiquen
                junit 'target/surefire-reports/*.xml' 
            } 
        }
        
        // ETAPA 3: Deploy (Despliegue con Docker)
        // Usa el agente principal (any) para acceder al motor Docker del Host
        stage('Deploy') { 
            steps {
                echo 'Desplegando en Docker.'
                sh "docker build -t ${DOCKER_IMAGE} ."
                sh "docker stop ${CONTAINER_NAME} || true" 
                sh "docker rm ${CONTAINER_NAME} || true"  
                sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
            }
        }
    }

    // Notificaciones
    post {
        always { archiveArtifacts artifacts: "target/${ARTIFACT_FILE}", fingerprint: true }
        
        success { 
            mail to: 'tu.correo@ejemplo.com', 
                 subject: "Éxito CI/CD: ${env.JOB_NAME}", 
                 body: "Pipeline ejecutado exitosamente. URL: ${env.BUILD_URL}"
        }
        
        failure { 
            // FIX: Se elimina la referencia a 'currentBuild.stage' para evitar MissingPropertyException
            mail to: 'tu.correo@ejemplo.com', 
                 subject: "FALLO CI/CD: ${env.JOB_NAME} - Falló la Etapa ${currentBuild.stagesWith)//.last().name}", 
                 body: "El Pipeline falló. Revisa los logs en: ${env.BUILD_URL}"
        }
    }
}

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
            // Usamos un agente Docker para obtener 'mvn' y JDK
            agent {
                docker {
                    image 'maven:3.9.6-openjdk-21' 
                    args '-v $HOME/.m2:/root/.m2' 
                }
            }
            steps { 
                echo 'Iniciando compilación...' 
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
            mail to: 'tu.correo@ejemplo.com', // << ACTUALIZAR CORREO
                 subject: "Éxito CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}", 
                 body: "Pipeline ejecutado exitosamente. URL: ${env.BUILD_URL}"
        }
        
        failure { 
            // FIX FINAL: Cuerpo del mensaje simplificado para evitar errores de sintaxis Groovy.
            mail to: 'tu.correo@ejemplo.com', // << ACTUALIZAR CORREO
                 subject: "FALLO CI/CD: ${env.JOB_NAME} #${env.BUILD_NUMBER}", 
                 body: "¡ALERTA! El Pipeline falló en una etapa. Revisa los logs en: ${env.BUILD_URL}"
        }
    }
}

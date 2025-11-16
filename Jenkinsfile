// Jenkinsfile

pipeline {
    agent any 

    environment {
        CONTAINER_NAME = "proyecto-ci-cd-running"
        ARTIFACT_FILE = "app-1.0-SNAPSHOT.jar"
        // Nombre de la imagen Docker a crear
        DOCKER_IMAGE = "proyecto-ci-cd:${env.BUILD_NUMBER}" 
    }

    stages {
        stage('Build') { steps { echo 'Iniciando compilación...' ; sh 'mvn -B clean package -DskipTests' } }
        stage('Test') { 
            steps { 
                echo 'Ejecutando pruebas...' ; sh 'mvn test' ; 
                junit 'target/surefire-reports/*.xml' 
            } 
        }
        stage('Deploy') { 
            steps {
                echo 'Desplegando en Docker.'
                // 1. Construir la imagen
                sh "docker build -t ${DOCKER_IMAGE} ."
                // 2. Detener y eliminar contenedor anterior
                sh "docker stop ${CONTAINER_NAME} || true" 
                sh "docker rm ${CONTAINER_NAME} || true"  
                // 3. Desplegar el nuevo contenedor
                sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
            }
        }
    }

    // Notificaciones
    post {
        always { archiveArtifacts artifacts: "target/${ARTIFACT_FILE}", fingerprint: true }
        success { 
            mail to: 'tu.correo@ejemplo.com', // << ACTUALIZAR CORREO
                 subject: "Éxito CI/CD: ${env.JOB_NAME}", 
                 body: "Pipeline ejecutado exitosamente. URL: ${env.BUILD_URL}"
        }
        failure { 
            mail to: 'tu.correo@ejemplo.com', // << ACTUALIZAR CORREO
                 subject: "FALLO CI/CD: ${env.JOB_NAME}", 
                 body: "El Pipeline falló en la etapa ${currentBuild.stage}. URL: ${env.BUILD_URL}"
        }
    }
}

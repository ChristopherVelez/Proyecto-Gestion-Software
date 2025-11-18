pipeline {
    agent any
    
    // 1. Configuración de Herramientas: 'M3'  Debe estar configurado en Global Tool Configuration
    tools {
    maven 'M3' 
    jdk 'JDK_23' 
}

    stages {
        // Build: Compila el código
        stage('Build') {
            steps {
                echo 'Iniciando compilación...'
                sh 'mvn clean compile'
            }
        }

        // Test: Ejecuta las pruebas unitarias
        stage('Test') {
            steps {
                echo 'Ejecutando pruebas unitarias...'
                sh 'mvn test'
            }
            post {
                always {
                    // Publica los resultados JUnit como evidencia
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        // Package: Crea el artefacto JAR/WAR
        stage('Package') {
            steps {
                echo 'Empaquetando artefacto...'
                sh 'mvn package -DskipTests'
            }
        }

        // Deploy: Despliegue en entorno de prueba local
        stage('Deploy (Local)') {
            steps {
                echo 'Desplegando aplicación en entorno de prueba local...'
                // Crea la carpeta 'deploy' y mueve el JAR generado
                sh 'mkdir -p deploy'
                sh 'cp target/*.jar deploy/'
                echo 'Despliegue completado en la carpeta /deploy.'
            }
        }
    }}

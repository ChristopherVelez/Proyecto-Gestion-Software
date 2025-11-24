//Es el bloque raíz que define todo el flujo de trabajo de CI/CD.
pipeline {
    agent any //Especifica dónde se ejecutará todo el Pipeline. any significa que Jenkins elegirá cualquier agente (nodo/ejecutor) disponible para correr el trabajo.

    tools {
        maven 'M3' //Le dice al Pipeline que use la instalación de Maven que está configurada globalmente en Jenkins bajo el nombre de alias 'M3'.
    }

    stages {

        stage('Build') {
            steps {
                echo 'Iniciando compilación...'
                sh 'mvn clean compile' // limpia los artefactos anteriores y copila el código
            }
        }

        stage('Test') {
            steps {
                echo 'Ejecutando pruebas unitarias...'
                sh 'mvn test' //Ejecuta el ciclo de vida test de Maven, el cual corre las pruebas unitarias.
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml' //toma los resultados de las pruebas unitarias y los publica para ser visualizados como reportes en Jenkins.
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Empaquetando artefacto...'
                sh 'mvn package -DskipTests' //Ejecuta el ciclo de vida package de Maven para crear el artefacto.
            }
        }

        stage('Deploy (Local)') {
            steps {
                echo 'Desplegando aplicación en entorno de prueba local...'
                sh 'mkdir -p deploy' //Crea un directorio llamado deploy si no existe.
                sh 'cp target/*.jar deploy/' //Copia el archivo .jar (el artefacto empaquetado) desde la carpeta target a la recién creada carpeta deploy.
                echo 'Despliegue completado en la carpeta /deploy.'
            }
        }
    }

    post {
        success {
            emailext(
                to: 'jeremyvelez328@gmail.com',
                subject: "Build EXITOSO: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "El build se completó correctamente.\nURL: ${env.BUILD_URL}"
            )
        }
        failure {
            emailext(
                to: 'jeremyvelez328@gmail.com',
                subject: "Build FALLIDO: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "El build ha fallado.\nURL: ${env.BUILD_URL}"
            )
        }
    }
}

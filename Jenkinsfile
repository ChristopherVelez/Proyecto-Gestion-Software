pipeline {
    agent any
    
    // 1. Configuración de Herramientas: Asume que 'M3' está configurado en Global Tool Configuration
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
    }

    // 2. Automatización: Notificaciones por Email
 //   post {
   //     success {
     //       echo "Pipeline completado correctamente. Enviando notificación a Christopher."
       //     mail(
         //       to: 'christopher.velezpul@ug.edu.ec',
           //     subject: "✅ ÉXITO: Pipeline ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
             //   body: "El proceso CI/CD fue exitoso. Artefacto desplegado. Revisar: ${env.BUILD_URL}"
  //          )
    //    }
      //  failure {
        //    echo "Pipeline falló. Enviando alerta a Christopher."
          //  mail(
            //    to: 'christopher.velezpul@ug.edu.ec',
              //  subject: "❌ FALLO: Pipeline ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                //body: "El pipeline falló en la etapa ${env.STAGE_NAME}. Por favor, revisa en: ${env.BUILD_URL}"
     //       )
       // }
       // always {
   //         echo "Pipeline finalizado."
  //      }
    //}
}

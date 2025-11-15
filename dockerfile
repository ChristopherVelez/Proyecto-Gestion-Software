# Dockerfile

# ETAPA 1: BUILD (Para compilar la aplicación)
# Usamos una imagen de Maven con OpenJDK 24 para construir
FROM maven:latest-openjdk-24 AS build 

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto y ejecuta el empaquetado
COPY . /app
RUN mvn clean package -DskipTests

# ----------------------------------------------------------------------------------

# ETAPA 2: RUNTIME (Para ejecutar la aplicación)
# Usamos una imagen ligera de JRE 24 para el despliegue
FROM openjdk:24-jre-slim

# Establece el directorio de trabajo para el ejecutable
WORKDIR /app

# Copia el JAR generado en la etapa 'build' al contenedor ligero
# ¡AJUSTADO! El nombre del JAR es "Proyecto-1.0-SNAPSHOT.jar"
COPY --from=build /app/target/Proyecto-1.0-SNAPSHOT.jar /app/app.jar

# Expone el puerto por defecto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
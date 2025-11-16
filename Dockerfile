# Dockerfile
FROM openjdk:latest-jre-slim 

WORKDIR /app
COPY target/app-1.0-SNAPSHOT.jar app.jar 
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]

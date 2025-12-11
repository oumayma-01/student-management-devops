FROM openjdk:17-jdk-slim

WORKDIR /app

# The 'target' directory is created by Maven in the build stage.
# We copy the executable JAR file. We assume the JAR starts with 'student-management-' 
# based on the project name and rename it to 'app.jar' for simplicity.
# If your Maven artifact ID is different, please adjust 'student-management-*.jar' below.
COPY target/student-management-*.jar app.jar

# Expose the port the Spring Boot application runs on (default is 8080)
EXPOSE 8080

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]

# Note: You can optionally add health checks or use multi-stage builds for smaller images.

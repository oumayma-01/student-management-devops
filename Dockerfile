# --- STAGE 1: Build the application (using JDK) ---
# Use a full JDK from Eclipse Temurin for building the project
FROM eclipse-temurin:17-jdk-focal AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
# This leverages Docker's layer caching for faster builds if pom.xml doesn't change
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Package the application into a single executable JAR file
RUN mvn package -DskipTests

# --- STAGE 2: Create the final, minimal image (using JRE) ---
# FIX: Using the reliable Eclipse Temurin JRE image instead of deprecated OpenJDK tags
FROM eclipse-temurin:17-jre-focal AS final

# Set the working directory for the final application
WORKDIR /app

# Copy the built JAR file from the build stage
# The JAR name is assumed to be 'target/student-management-0.0.1-SNAPSHOT.jar'
# Adjust the JAR name below if your Maven build produces a different name
COPY --from=build /app/target/*.jar app.jar

# Expose the port the Spring Boot application runs on (default is 8080)
EXPOSE 8080

# The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

#test final hopefulllyyyyyyy :( finaaal 3 !!!!
# ------------------------------------
# Stage 1: Build the application (using JDK)
# ------------------------------------
FROM eclipse-temurin:17-jdk-focal AS builder

WORKDIR /app

# Copy necessary files for the build
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src ./src

# FIX: Grant execute permission to the Maven Wrapper script
# This ensures the script can be executed inside the container
RUN chmod +x ./mvnw

# Package the application (skipping tests as they were run in the pipeline)
RUN ./mvnw clean package -DskipTests

# ------------------------------------
# Stage 2: Create the final lean runtime image (using JRE)
# ------------------------------------
FROM eclipse-temurin:17-jre-focal AS stage-1

WORKDIR /app

# Copy the generated JAR file from the builder stage
# Adjust the filename pattern if necessary (e.g. if artifactId is different)
COPY --from=builder /app/target/student-management-*.jar app.jar

# Application port
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

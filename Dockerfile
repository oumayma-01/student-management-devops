# --- STAGE 1: BUILD (using Temurin JDK) ---
# Use the JDK image to build the application
FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app

# Copy Maven wrapper files and pom.xml
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

# Copy source code (assuming src/ exists)
COPY src ./src

# Build the application package. We skip tests here since they ran in the pipeline,
# but usually they would run in this stage inside the Dockerfile.
RUN ./mvnw clean package -DskipTests

# --- STAGE 2: FINAL (using smaller Temurin JRE) ---
# Use the smaller JRE image for the final runtime environment
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

# Copy the generated JAR from the 'builder' stage
# The name comes from the pom.xml artifactId (student-management) and version (0.0.1-SNAPSHOT)
COPY --from=builder /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Define the port the Spring Boot app runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

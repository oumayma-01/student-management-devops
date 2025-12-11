FROM eclipse-temurin:17-jdk-focal AS builder

WORKDIR /app

Copy necessary files for the build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src ./src


RUN chmod +x ./mvnw

RUN ./mvnw clean package -DskipTests


FROM eclipse-temurin:17-jre-focal AS stage-1

WORKDIR /app

Copy the generated JAR file from the builder stage

COPY --from=builder /app/target/student-management-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

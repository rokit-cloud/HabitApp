# Stage 1: Build application
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /workspace

COPY pom.xml .
COPY src ./src

RUN mvn -B -DskipTests package

# Stage 2: Runtime image
FROM eclipse-temurin:21-jre

WORKDIR /app

RUN groupadd --system spring \
    && useradd --system --gid spring --home-dir /app spring

COPY --from=builder --chown=spring:spring \
    /workspace/target/habit-tracker.jar /app/app.jar

USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

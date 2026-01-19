# -------- Build stage --------
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

COPY gradlew build.gradle settings.gradle /app/
COPY gradle /app/gradle
COPY src /app/src

RUN chmod +x gradlew && ./gradlew clean bootJar -x test

# -------- Runtime stage --------
FROM eclipse-temurin:21-jre
WORKDIR /app

ENV TZ=UTC
ENV JAVA_OPTS=""

COPY --from=build /app/build/libs/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
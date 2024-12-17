# Build stage
FROM  maven:3.9.6-eclipse-temurin-17-alpine AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean test package

# Package stage
FROM eclipse-temurin:17-jre-jammy
COPY --from=build /home/app/target/*.jar app.jar
COPY system.properties /app/system.properties
EXPOSE 8080
ENTRYPOINT ["java","-Dspring.config.location=classpath:/,file:/app/system.properties","-jar","app.jar"]
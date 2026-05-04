FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml ./
COPY src ./src
COPY WebContent ./WebContent

RUN mvn -q -DskipTests clean package

FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat

RUN rm -rf webapps/*
COPY --from=build /app/target/DhwaniPortfolio.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

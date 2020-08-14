FROM openjdk:11

RUN mkdir /app
RUN mkdir /conf

VOLUME /tmp

ARG JAR_FILE=build/libs/*.jar

COPY ${JAR_FILE} /app/app.jar
COPY /build/resources/main/application.yml /conf/application.yml


ENTRYPOINT ["java","-jar","-Dspring.config.location=/conf/application.yml","app/app.jar"]
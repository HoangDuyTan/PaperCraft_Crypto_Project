FROM gradle:9.2-jdk21 AS build
USER root
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN cp src/main/webapp/META-INF/context-docker.xml src/main/webapp/META-INF/context.xml
RUN chmod +x gradlew
RUN ./gradlew war --no-daemon

FROM tomcat:10.1.49-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /home/gradle/src/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
FROM openjdk:8u121-jdk-alpine
MAINTAINER Sayali Kale

# Update package Manager and create project directory
RUN apk update
RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

# Copy jar file from jenkins to swarm manager server
COPY target/*.jar ${PROJECT_HOME}/spring-boot-mongo.jar

# Set pwd as PROJECT_HOME
WORKDIR ${PROJECT_HOME}

# Start the spring-boot Application
CMD ["java","-jar","./spring-boot-mongo.jar"]

# Step 1: Build the Spring Boot application
# Use an official Maven image to build the application
FROM maven:3.9.9-eclipse-temurin-17 AS build
ENV HOME=/usr/app
# Set the working directory
RUN mkdir -p $HOME
WORKDIR $HOME
# Copy the pom.xml and source code into the container
COPY . $HOME
# Run Maven to build the application (creates the .jar file)
RUN mvn -f $HOME/pom.xml clean package

# Step 2: Prepare the runtime environment
# Use a slim OpenJDK image to run the application
FROM openjdk:17-slim
# Set the working directory for the runtime container
RUN mkdir -p /usr/webapp
# Copy the compiled jar file from the build stage
COPY --from=build /usr/app/target/*.jar /usr/webapp/app.jar
# Expose the port the application will run on
EXPOSE 8081
# Command to run the application
ENTRYPOINT ["java","-jar","/usr/webapp/app.jar"]
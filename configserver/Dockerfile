#Start with a base image containing Java runtime
FROM eclipse-temurin:25-jdk

# MAINTAINER instruction is deprecated in favor of using label
# MAINTAINER ipsitasarkar
#Information around who maintains the image
LABEL "org.opencontainers.image.authors"="ipsitasarkar"

# Add the application's jar to the image
COPY target/configserver-0.0.1-SNAPSHOT.jar configserver-0.0.1-SNAPSHOT.jar

# execute the application
ENTRYPOINT ["java", "-jar", "configserver-0.0.1-SNAPSHOT.jar"]
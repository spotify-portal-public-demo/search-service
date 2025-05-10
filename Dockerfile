FROM amazoncorretto:21-alpine
ENTRYPOINT ["/usr/bin/search-service.sh"]

COPY search-service.sh /usr/bin/search-service.sh
COPY target/*.jar /usr/share/search-service/search-service.jar

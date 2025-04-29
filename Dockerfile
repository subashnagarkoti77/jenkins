FROM tomcat:9-jre21-temurin-noble
COPY **/*.war /usr/local/tomcat/webapps/subash.war
EXPOSE 8080
CMD ["catalina.sh","run"]

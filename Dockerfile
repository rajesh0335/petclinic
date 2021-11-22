# we are extending everything from tomcat:8.0 image ...
FROM jboss/wildfly
MAINTAINER Anil Pemmaraju
# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat
COPY target/petclinic.war /opt/jboss/wildfly/standalone/deployments/petclinic.war

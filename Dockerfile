FROM jenkins:2.7.3

USER root

RUN mkdir -p /var/jenkins_home/init.groovy.d/

COPY config.sh /opt/bin/config.sh
COPY jenkins-config/basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy
# COPY jenkins-config.xml /opt/bin/jenkins-config.xml

RUN chmod +x /opt/bin/config.sh

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/bin/tini", "--", "/opt/bin/config.sh"]

FROM jenkins:2.7.3

USER root

RUN mkdir -p /var/jenkins_home/init.groovy.d/

COPY config.sh /opt/bin/config.sh
COPY jenkins-config/basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy
# COPY jenkins-config.xml /opt/bin/jenkins-config.xml

RUN mkdir -p /var/jenkins_home/workspace/seed/jobs \
    && mkdir -p /var/jenkins_home/workspace/seed/helpers \
    && mkdir -p /var/jenkins_home/jobs/seed

COPY jobs/seed.xml /var/jenkins_home/jobs/seed/config.xml
COPY jobs/canary.groovy /var/jenkins_home/workspace/seed/jobs/canary.groovy
COPY jobs/common.groovy /var/jenkins_home/workspace/seed/helpers/common.groovy

RUN chmod +x /opt/bin/config.sh \
    && /usr/local/bin/install-plugins.sh ansicolor \
                                         greenballs \
                                         groovy-postbuild \
                                         job-dsl \
                                         workflow-aggregator

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/bin/tini", "--", "/opt/bin/config.sh"]

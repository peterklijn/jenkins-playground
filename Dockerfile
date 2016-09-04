FROM jenkins:2.7.3

USER root

RUN /usr/local/bin/install-plugins.sh ansicolor \
                                         greenballs \
                                         groovy-postbuild \
                                         rebuild \
                                         postbuildscript \
                                         job-dsl \
                                         workflow-aggregator \
                                         ws-cleanup

RUN mkdir -p /var/jenkins_home/init.groovy.d/ \
    && mkdir -p /var/jenkins_home/jobs/seed/workspace/helpers

COPY config.sh /opt/bin/config.sh
COPY jenkins-config/basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy

COPY jobs/seed.xml /var/jenkins_home/jobs/seed/config.xml
COPY jobs/canary.groovy /var/jenkins_home/jobs/seed/workspace/canary.groovy
COPY jobs/helpers/common.groovy /var/jenkins_home/jobs/seed/workspace/helpers/common.groovy

RUN chmod +x /opt/bin/config.sh

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/bin/tini", "--", "/opt/bin/config.sh"]

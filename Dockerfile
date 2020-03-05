FROM jenkins/jenkins:2.204.4

USER root

RUN /usr/local/bin/install-plugins.sh \
                                     rebuild \
                                     job-dsl

ENV DEMO_JOB_DIR="/opt/bin/jobs/" \
    SEED_JOB_WORKSPACE_DIR="/var/jenkins_home/jobs/seed/workspace/"

RUN mkdir -p /var/jenkins_home/init.groovy.d/ \
    && mkdir -p /var/jenkins_home/jobs/seed/workspace/helpers \
    && ln -s /var/jenkins_home/jobs/seed /.

COPY config.sh /opt/bin/config.sh

COPY jenkins-config/basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy

COPY jenkins-seedjob-config.xml /var/jenkins_home/jobs/seed/config.xml

COPY jobs/ $DEMO_JOB_DIR

RUN chmod +x /opt/bin/config.sh

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/sbin/tini", "--", "/opt/bin/config.sh"]

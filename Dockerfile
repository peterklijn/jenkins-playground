FROM jenkins:2.7.3

USER root

COPY config.sh /opt/bin/config.sh

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

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

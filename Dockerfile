FROM jenkins:2.7.3

USER root

COPY config.sh /opt/bin/config.sh
COPY plugins.txt plugins.txt

RUN chmod +x /opt/bin/config.sh \
    && /usr/local/bin/install-plugins.sh ansicolor \
                                         greenballs \
                                         groovy-postbuild \
                                         job-dsl \
                                         workflow-aggregator

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

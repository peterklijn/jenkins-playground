FROM jenkins:2.7.3

USER root

COPY config.sh /opt/bin/config.sh

RUN chmod +x /opt/bin/config.sh

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

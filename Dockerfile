FROM jenkins:2.7.3

USER root

COPY config.sh /opt/bin/config.sh
COPY plugins.txt /opt/bin/plugins.txt

RUN chmod +x /opt/bin/config.sh \
    && /usr/local/bin/plugins.sh /opt/bin/plugins.txt

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# Dockerfile for rundeck
# initially copied fromhttps://github.com/jjethwa/rundeck
# now on https://github.com/eugenmayer/rundeck

FROM debian:stretch
ARG RUNDECK_VERSION=3.0.7.20181008-1.201810082317
ARG RUNDECK_CLI_VERSION=0.1.30

ENV SERVER_URL=https://localhost:4443 \
    RUNDECK_STORAGE_PROVIDER=file \
    RUNDECK_PROJECT_STORAGE_TYPE=file \
    LOGIN_MODULE=RDpropertyfilelogin \
    JAAS_CONF_FILE=jaas-loginmodule.conf \
    KEYSTORE_PASS=adminadmin \
    TRUSTSTORE_PASS=adminadmin

RUN export DEBIAN_FRONTEND=noninteractive && \
    echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qqy install -t stretch-backports --no-install-recommends bash openjdk-8-jre-headless ca-certificates-java supervisor procps sudo ca-certificates openssh-client pwgen curl uuid-runtime parallel && \
    cd /tmp/ && \
    curl -Lo /tmp/rundeck.deb http://dl.bintray.com/rundeck/rundeck-deb/rundeck_${RUNDECK_VERSION}_all.deb && \
    # echo '38937c90592ee9ca085bdec65dbbbb0693db2b85772ef5860ac856e044002aa0  rundeck.deb' > /tmp/rundeck.sig && \
    # shasum -a256 -c /tmp/rundeck.sig && \
    curl -Lo /tmp/rundeck-cli.deb http://dl.bintray.com/rundeck/rundeck-deb/rundeck-cli_${RUNDECK_CLI_VERSION}-1_all.deb

RUN cd - && \
    dpkg -i /tmp/rundeck*.deb && rm /tmp/rundeck*.deb && \
    chown rundeck:rundeck /tmp/rundeck && \
    mkdir -p /var/lib/rundeck/.ssh && \
    chown rundeck:rundeck /var/lib/rundeck/.ssh && \
    sed -i "s/export RDECK_JVM=\"/export RDECK_JVM=\"\${RDECK_JVM} /" /etc/rundeck/profile && \
    cd - && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY rundeck-defaults /opt/rundeck-defaults
COPY supervisor /etc/supervisor
COPY bin/docker-entrypoint.sh /
COPY bin/custom-scripts.sh /
COPY bin/rundeck-wrapper.sh /usr/local/bin/rundeck-wrapper
COPY bin/wait-for-it.sh /usr/local/bin/wait-for-it

RUN mkdir -p /var/log/supervisor /opt/supervisor /docker-entrypoint.d/ && \
    chmod u+x /usr/local/bin/rundeck-wrapper /docker-entrypoint.sh /custom-scripts.sh

EXPOSE 4440 4443

## TODOL should we remove /var/lib/rundeck ?
VOLUME  ["/etc/rundeck", "/var/rundeck", "/var/lib/rundeck", "/var/log/rundeck", "/opt/rundeck-plugins", "/var/lib/rundeck/logs", "/var/lib/rundeck/var/storage"]

ENTRYPOINT ["/docker-entrypoint.sh"]

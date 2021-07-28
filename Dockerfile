FROM adoptopenjdk/openjdk11:debian
ARG RUNDECK_VERSION=
ARG RUNDECK_CLI_VERSION=1.3.10

ENV SERVER_URL=https://localhost:4443 \
    RUNDECK_STORAGE_PROVIDER=file \
    RUNDECK_PROJECT_STORAGE_TYPE=file \
    LOGIN_MODULE=RDpropertyfilelogin \
    JAAS_CONF_FILE=jaas-loginmodule.conf \
    KEYSTORE_PASS=adminadmin \
    TRUSTSTORE_PASS=adminadmin

# we use a custom build of the client due to https://github.com/rundeck/rundeck-cli/issues/341
RUN mkdir -p /opt/rundeck-cli
#COPY bin/rundeck-cli-1.3.4-dev.jar /opt/rundeck-cli/rundeck-cli.jar
COPY bin/rd.sh /usr/bin/rd

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends bash procps sudo ca-certificates ca-certificates-java curl gnupg2 \
    openssh-client software-properties-common curl uuid-runtime \
    && apt install -y supervisor \

    && curl https://raw.githubusercontent.com/rundeck/packaging/main/scripts/deb-setup.sh 2> /dev/null | bash -s rundeck \
    && apt update && apt install -y rundeck \

    && chmod +x /usr/bin/rd \
    && apt-get install -y rundeck-cli \

    && mkdir -p /var/lib/rundeck/.ssh \
    && chown rundeck:rundeck /var/lib/rundeck/.ssh \
    && sed -i "s/export RDECK_JVM=\"/export RDECK_JVM=\"\${RDECK_JVM} /" /etc/rundeck/profile \

    && rm -rf /tmp/* /var/tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -fr /tmp/*.deb \
    && rm -rf /usr/share/man/?? \
    && rm -rf /usr/share/man/??_*


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

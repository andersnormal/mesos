ARG MESOS_IMAGE=andersnormal/mesos:1.6.1

FROM $MESOS_IMAGE

ARG MAINTAINER

ENV MAINTAINER ${MAINTAINER:-sebastian@andersnormal.us}

LABEL us.andersnormal.vendor="Anders Normal"
LABEL version="${VERSION}"
LABEL description="Mesos Master inside"
LABEL maintainer="${MAINTAINER}"

RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install curl apt-transport-https ca-certificates

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

RUN \
    # http://docs.docker.com/installation/ubuntulinux/
    curl -fLsS https://get.docker.com/ | sh && test -x /usr/bin/docker && \
    # curl -sSL https://dl.bintray.com/emccode/dvdcli/install | sh -s stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY \
    init.sh /

RUN \
    chmod +x /init.sh

CMD ["/usr/sbin/mesos-slave", "--no-hostname_lookup"]

ENV MESOS_WORK_DIR /tmp/mesos
ENV MESOS_CONTAINERIZERS docker,mesos

# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

# https://issues.apache.org/jira/browse/MESOS-4675
ENV MESOS_SYSTEMD_ENABLE_SUPPORT false

VOLUME /tmp/mesos

ENTRYPOINT ["/usr/local/bin/dumb-init", "/init.sh"]
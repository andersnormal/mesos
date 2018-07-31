ARG MESOS_IMAGE=andersnormal/mesos:1.6.1

FROM $MESOS_IMAGE

ARG MESOS_VERSION
ARG MAINTAINER

ENV VERSION ${MESOS_VERSION:-1.6.1}
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

COPY \
    init.sh /

RUN \
    chmod +x /init.sh

CMD ["/usr/sbin/mesos-master", "--registry=in_memory", "--no-hostname_lookup", "true"]

ENV MESOS_WORK_DIR /tmp/mesos

VOLUME /tmp/mesos

ENTRYPOINT ["/usr/local/bin/dumb-init", "/init.sh"]
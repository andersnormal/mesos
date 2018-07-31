FROM alpine:latest as build

ARG EXHIBITOR_VERSION
ENV EXHIBITOR_VERSION=${EXHIBITOR_VERSION:-1.7.2} \
    JAVA_HOME="/usr/lib/jvm/default-jvm" \
    BUILD_DEPS="openjdk8 maven curl bash tar" \
    BUILD_HOME="/tmp/exhibitor" \
    POM_FILE="https://raw.githubusercontent.com/soabase/exhibitor/exhibitor-${EXHIBITOR_VERSION}/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml"

RUN \
    # Install build deps
    apk add --update ${BUILD_DEPS} && \

    # Download release, and extract
    mkdir -p ${BUILD_HOME} && \
    curl -Lo ${BUILD_HOME}/pom.xml ${POM_FILE} && \
    mvn -f ${BUILD_HOME}/pom.xml package && \

    # Link
    ln -s ${BUILD_HOME}/target/exhibitor*jar ${BUILD_HOME}/exhibitor.jar

FROM openjdk:8-jdk-alpine

ARG EXHIBITOR_HOME
ARG ZOOKEEPER_HOME
ARG ZOOKEEPER_VERSION
ENV \
    ZOOKEEPER_HOME=${ZOOKEEPER_HOME:-/opt/zookeeper} \
    ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION:-3.4.11} \
    EXHIBITOR_HOME=${EXHIBITOR_HOME:-/opt/exhibitor} \
    EXHIBITOR_DEPS="bash curl jq"

LABEL us.andersnormal.vendor="Anders Normal"
LABEL version="${VERSION}"
LABEL description="Zookeeper + Exhibitor"
LABEL maintainer="${MAINTAINER}"

RUN \
    # Temp
    export TEMP=$(mktemp -d) && \
    # Install deps
    apk add --update --cache-dir=${TEMP} ${EXHIBITOR_DEPS} && \
    # Create folders
    mkdir -p ${JAVA_PREFS} ${ZOOKEEPER_HOME} ${EXHIBITOR_HOME} && \
    # Zookeper release
    wget -O ${TEMP}/zookeeper.tar.gz http://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    tar -xzf ${TEMP}/zookeeper.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1

COPY \
    --from=build /tmp/exhibitor/exhibitor.jar $EXHIBITOR_HOME

RUN \
    # Permissions
    chown -R nobody.nobody ${JAVA_PREFS} ${ZOOKEEPER_HOME} ${EXHIBITOR_HOME} \

    # Default DNS cache TTL is -1. DNS records, like, change, man
    && grep '^networkaddress.cache.ttl=' ${JAVA_HOME}/jre/lib/security/java.security || echo 'networkaddress.cache.ttl=60' >> ${JAVA_HOME}/jre/lib/security/java.security \

    # Cleanup
    && rm -rf ${TEMP}

# Add the wrapper script to setup configs and exec exhibitor
ADD \
    wrapper.sh ${EXHIBITOR_HOME}/wrapper.sh

# Add the optional web.xml for authentication
ADD \
    web.xml ${EXHIBITOR_HOME}/web.xml

USER nobody
WORKDIR /opt/exhibitor
EXPOSE 2181 2888 3888 8181

ENTRYPOINT ["bash", "-ex", "/opt/exhibitor/wrapper.sh"]
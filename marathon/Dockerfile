ARG MESOS_IMAGE=andersnormal/mesos:1.6.1

FROM $MESOS_IMAGE as build

ARG VERSION
ENV VERSION ${MARATHON_VERSION:-1.6.322}

RUN \
    # Update the packages.
    apt-get -y update && \
    # Install neat tools
    apt-get install -y tar wget git ca-certificates-java && \
    # Install a few utility tools.
    apt-get install -y openjdk-8-jdk && \
    # Install the latest OpenJDK.
    apt-get install -y autoconf libtool && \
    # Install other Mesos dependencies.
    apt-get -y --no-install-recommends install build-essential

RUN \
    # Temp
    export TEMP=$(mktemp -d) && \
    # Change dir
    cd ${TEMP} && \
    # Clone source
    git clone --depth=1 --branch v${VERSION} https://github.com/mesosphere/marathon.git . && \
    # # Get sbt version
    eval $(sed s/sbt.version/SBT_VERSION/ <project/build.properties) && \
    wget -qO- https://piccolo.link/sbt-$SBT_VERSION.tgz | tar xvz -C ./  && \
    cp sbt/bin/sbt-launch.jar /usr/local/bin && \
    cp project/sbt /usr/local/bin && \
    chmod +x /usr/local/bin/sbt && \
    # Build
    sbt -Dsbt.log.format=false universal:packageZipTarball && \
    # Move into place
    mv $(find target -name 'marathon-*.tgz' | sort | tail -1) /tmp

FROM ubuntu:xenial

ARG VERSION
ARG MAINTAINER

ENV VERSION ${MARATHON_VERSION:-1.6.322}
ENV MAINTAINER ${MAINTAINER:-sebastian@andersnormal.us}

LABEL us.andersnormal.vendor="Anders Normal"
LABEL version="${VERSION}"
LABEL description="Mesos inside"
LABEL maintainer="${MAINTAINER}"

COPY \
     --from=build /tmp/marathon-*.tgz /tmp

RUN \
    # Extract && delete
    tar --strip-components=1 -xzvf /tmp/marathon-*.tgz -C / && rm -rf /tmp/*.tgz && \
    # Update the packages.
    apt-get -y update && \
    # Install neat tools
    apt-get install -y ca-certificates-java && \
    # jdk setup
    /var/lib/dpkg/info/ca-certificates-java.postinst configure && \
    ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home && \
    # clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JAVA_HOME /docker-java-home
ENTRYPOINT ["./bin/marathon"]
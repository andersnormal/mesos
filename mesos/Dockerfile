FROM ubuntu:xenial as build

ARG MESOS_VERSION
ARG MAINTAINER

ENV VERSION ${MESOS_VERSION:-1.6.1}
ENV MAINTAINER ${MAINTAINER:-sebastian@andersnormal.us}

RUN \
    apt-get -y update && \
    # Update the packages.
    apt-get install -y tar wget git && \
    # Install a few utility tools.
    apt-get install -y openjdk-8-jdk && \
    # Install the latest OpenJDK.
    apt-get install -y autoconf libtool && \
    # Install other Mesos dependencies.
    apt-get -y install build-essential python-dev python-six python-virtualenv libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev ruby ruby-dev python-dev autoconf automake git make libssl-dev libcurl3 libtool && \
    # fpm
    gem install fpm

WORKDIR /mesos

RUN \
    # Temp
    export TEMP=$(mktemp -d) && \
    # Change dir
    cd ${TEMP} && \
    # Clone build root
    git clone --depth=1 https://github.com/katallaxie/mesos-deb-packaging.git . && \
    # build
    ./build_mesos --repo https://git-wip-us.apache.org/repos/asf/mesos.git?ref=${VERSION} && \
    # copy 
    mv pkg.deb ../

FROM ubuntu:xenial

LABEL us.andersnormal.vendor="Anders Normal"
LABEL version="${VERSION}"
LABEL description="Mesos inside"
LABEL maintainer="${MAINTAINER}"

COPY \
    --from=build /tmp/pkg.deb /tmp

RUN \
    apt-get -y update && \
    apt-get -y --no-install-recommends install openjdk-8-jre-headless && \
    dpkg -i --force-all /tmp/pkg.deb && \
    apt-get -y install -f && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
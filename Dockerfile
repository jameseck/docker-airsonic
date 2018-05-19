FROM centos:7

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ARG AIRSONIC_VERSION=v10.1.1
ARG AIRSONIC_URL=https://github.com/airsonic/airsonic/releases/download/v10.1.1/airsonic.war

RUN \
  yum install -y epel-release yum-utils && \
  yum localinstall -y --nogpgcheck \
    https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
    https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm && \
  yum install -y curl ffmpeg lame java-1.8.0-openjdk wget && \
  yum clean all && \
  rm -rf /var/cache/yum/*
RUN \
  mkdir --mode=0775 /airsonic && \
  curl -L "${AIRSONIC_URL}" -o /airsonic/airsonic.war && \
  chmod -R 0775 /var/log /airsonic

ADD run.sh /usr/local/bin/

WORKDIR /airsonic

ENV \
  AIRSONIC_DIR=/airsonic \
  AIRSONIC_PORT=4040 \
  CONTEXT_PATH=/ \
  JAVA_OPTS=""

EXPOSE 4040

VOLUME ["/airsonic/config"]

ENTRYPOINT [ "bash", "/usr/local/bin/run.sh" ]

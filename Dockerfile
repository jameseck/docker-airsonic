FROM centos:7

MAINTAINER James Eckersall <james.eckersall@gmail.com>

ARG AIRSONIC_VERSION=bob
ARG AIRSONIC_URL=bob

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

EXPOSE 4040

VOLUME ["/airsonic/config"]

ENTRYPOINT [ "/usr/local/bin/run.sh" ]
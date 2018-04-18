# Build a docker container to run the latest stable release of Ubiquiti's
# UniFi controller
#
# UniFi contoller is used to administer Ubiquiti wireless access points
#
FROM ubuntu:latest
MAINTAINER dmreiland@unixsherpa.com

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/lib/unifi/data && \
  	touch /usr/lib/unifi/data/.unifidatadir && \
    apt-get update -q -y && \
    apt-get install -q -y apt-utils lsb-release curl wget rsync openjdk-8-jre && \
    echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/ubiquity.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 06E85760C0A52C50 && \
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" >> /etc/apt/sources.list.d/ubiquity.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    apt-get update -q -y && \
    apt-get install -q -y mongodb-org && \
    apt-get install -q -y unifi

COPY scripts/init.sh /usr/local/bin/init.sh
COPY scripts/mongod.conf /etc/mongod.conf

VOLUME /usr/lib/unifi/data
EXPOSE  8443 8080 27117 3478/udp
WORKDIR /usr/lib/unifi
ENTRYPOINT ["/bin/bash", "/usr/local/bin/init.sh"]

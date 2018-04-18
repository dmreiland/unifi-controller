#!/bin/bash

function log() {
  local msg=$1
  echo "===> ${msg}..."
}

function start_servers() {
    #systemctl start mongod && \
    mongod --config /etc/mongod.conf && \
    /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -Xmx512M -jar /usr/lib/unifi/lib/ace.jar start
}

# main
log "starting mongod, unifi"
start_servers

#!/bin/bash

function log() {
  local msg=$1
  echo "===> ${msg}..."
}

function start_servers() {
    mv /usr/bin/mongod.sh /usr/bin/mongod && chmod a+x /usr/bin/mongod
    java -Xmx512M -jar /usr/lib/unifi/lib/ace.jar start
}

# main
log "starting mongod, unifi"
start_servers

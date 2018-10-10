[![Docker Stars](https://img.shields.io/docker/stars/dmreiland/unifi-controller.svg?style=flat-square)](https://hub.docker.com/r/dmreiland/unifi-controller/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmreiland/unifi-controller.svg?style=flat-square)](https://hub.docker.com/r/dmreiland/unifi-controller/)

# UniFi Controller

A simple Docker container for Ubiquiti's UniFi controller.


# Versions

`latest` (`master`) branch download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:latest.svg)](http://microbadger.com/images/dmreiland/unifi-controller:latest "Get your own image badge on microbadger.com")

Latest stable version of the UniFi controller.

`lts` branch download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:lts.svg)](http://microbadger.com/images/dmreiland/unifi-controller:lts "Get your own image badge on microbadger.com")

Long Term Support version of the UniFi controller (includes support for legacy devices abandoned in v5.7.20).


# Tags for MongoDB 2.6 - 3.6 (to provide an upgrade path for data persistence).

`MongoDB 2.6` tag download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:mongodb_2.6.svg)](http://microbadger.com/images/dmreiland/unifi-controller:mongodb_2.6 "Get your own image badge on microbadger.com")


`MongoDB 3.0` tag download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:mongodb_3.0.svg)](http://microbadger.com/images/dmreiland/unifi-controller:mongodb_3.0 "Get your own image badge on microbadger.com")


`MongoDB 3.2` tag download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:mongodb_3.2.svg)](http://microbadger.com/images/dmreiland/unifi-controller:mongodb_3.2 "Get your own image badge on microbadger.com")


`MongoDB 3.4` tag download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:mongodb_3.4.svg)](http://microbadger.com/images/dmreiland/unifi-controller:mongodb_3.4 "Get your own image badge on microbadger.com")


`MongoDB 3.6` tag download image size is:

[![](https://images.microbadger.com/badges/image/dmreiland/unifi-controller:mongodb_3.6.svg)](http://microbadger.com/images/dmreiland/unifi-controller:mongodb_3.6 "Get your own image badge on microbadger.com")


# Use

It's a Docker container -- just run it like you would any other.

    docker run -d \
    -p 8080:8080/tcp \
    -p 8443:8443/tcp \
    -p 37117:27117/tcp \
    -p 3478:3478/udp \
    -p 6789:6789/tcp \
    -p 8883:8883/tcp \
    -v /local/data:/usr/lib/unifi/data \
    --name unifi dmreiland/unifi-controller:latest

We assume that you will be persisting your Mongo datastore outside of the container. Map it via ``-v``. Ports can be remapped to suit your environment.

# Upgrading MongoDB

You may not need to upgrade your MongoDB datastore, however, we did. Mongo's prescribed upgrade path is to step through __each__ release between the version you are on and the version you intend to upgrade to. In our case, we had to upgrade from ``2.6 -> 3.0 -> 3.2 -> 3.4 -> 3.6``.

Upgrading from 3.4 to 3.6 requires the ``featureCompatibilityVersion`` parameter to be set. The process for setting this parameter is:

- open an interactive session to your running UniFi Docker container


      docker exec -it <your container id> "/bin/bash"
      mongo localhost:27117

- At the ``>`` prompt issue the following commands:


      db.adminCommand( { getParameter: 1, featureCompatibilityVersion:  } )
      db.adminCommand( { setFeatureCompatibilityVersion: "3.4" } )


The first command will return the current value of the `featureCompatibilityVersion parameter. The second command will set the parameter to 3.4 (required to upgrade to MongoDB 3.6).


# Troubleshooting

We encountered an issue upon upgrading to 5.7.20. Immediately after logging in to the admin console, you are presented with a
``400: Bad Request error``. To resolve, do the following:

- open an interactive session to your running UniFi Docker container


      docker exec -it <your container id> "/bin/bash"
      mongo localhost:27117/ace


- At the ``>`` prompt issue the following commands:


      db.setting.update({key:'super_mgmt'},{$unset:{site_id:1}})
      exit


See: https://community.ubnt.com/t5/UniFi-Wireless/CAREFUL-5-7-20-update-broke-my-controller/td-p/2281959

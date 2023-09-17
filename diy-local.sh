#!/bin/bash

./scripts/feeds update helloworld
./scripts/feeds install -a -p helloworld

./scripts/feeds update passwall
./scripts/feeds install -a -p passwall

./scripts/feeds update passwall_packages
./scripts/feeds install -a -p passwall_packages


# sudo rsync -avh --remove-source-files --ignore-existing --progress \
# /mnt/e/openwrt/build_openwrt/ \
#  /build_openwrt/ 
 
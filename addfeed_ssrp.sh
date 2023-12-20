#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

#[ShadowSocksR Plus+] 菜單標題
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        https://github.com/dzw/ssrp.git^a33d777e866e537a72472d8b90ebbb1cb434c746"                         >> "feeds.conf.default"

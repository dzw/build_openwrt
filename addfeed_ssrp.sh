#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

#[ShadowSocksR Plus+] 菜單標題
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        https://github.com/fw876/helloworld.git"                         >> "feeds.conf.default"

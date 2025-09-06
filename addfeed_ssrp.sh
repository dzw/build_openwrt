#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

#[ShadowSocksR Plus+] 菜單標題

sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"

# echo "src-git helloworld https://github.com/dzw/ssrp.git^a33d777e866e537a72472d8b90ebbb1cb434c746" >> "feeds.conf.default"
# hysteria: update to 2.1.1
# echo "src-git helloworld https://github.com/dzw/ssrp.git^cbaf9ad7cdcf55ff2d54c12ef4ea218e3e36f225" >> "feeds.conf.default"

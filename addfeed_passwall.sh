#!/bin/bash

# [Pass Wall] 菜單標題

sed -i "/passwall_packages/d" "feeds.conf.default"
sed -i "/passwall_luci/d" "feeds.conf.default"
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall_luci     https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"

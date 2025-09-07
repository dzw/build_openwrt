#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

# #[Pass Wall] 菜單標題 
# WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist

echo "src-git passwall_packages \ 
 https://github.com/xiaorouji/openwrt-passwall-packages.git;main" \
 >> "feeds.conf.default"

echo "src-git passwall_luci          \ 
 https://github.com/xiaorouji/openwrt-passwall.git;main"         \
 >> "feeds.conf.default"

# [ShadowSocksR Plus+] 顯示菜單
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        \ 
 https://github.com/fw876/helloworld.git^a33d777e866e537a72472d8b90ebbb1cb434c746" \
 >> "feeds.conf.default"

#[Hello World] 顯示菜單 節點導入失敗
# WARNING: Makefile 'package/lean/luci-app-vssr/Makefile' has a dependency on 'pdnsd-alt', which does not exist
# git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr.git    package/lean/luci-app-vssr
# git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb.git    package/lean/lua-maxminddb
# git pull

# mkdir dl
# git clone –depth 1 git@gitee.com:kwill/openwrt-dependent-dl.git dl
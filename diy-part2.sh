#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

echo "$(pwd)"

# git apply $GITHUB_WORKSPACE/patches/*.patch
# error: can't open patch '/home/runner/work/build_openwrt/build_openwrt/patches/*.patch': No such file or directory
git apply $GITHUB_WORKSPACE/patches/$REPO_BRANCH.diff

# ./scripts/feeds update packages
rm -rf feeds/packages/lang/golang
# svn co     https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang
svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

# cd openwrt/package
# pushd package

    git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

    #[Hello World] 顯示菜單 Hello World 節點導入失敗
    # git clone https://github.com/jerrykuku/luci-app-vssr.git    package/lean/luci-app-vssr
    # git clone https://github.com/jerrykuku/lua-maxminddb.git    package/lean/lua-maxminddb

# popd
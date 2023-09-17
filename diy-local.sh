#!/bin/bash

GITHUB_WORKSPACE=/build_openwrt/

REPO_URL=https://gitee.com/mybsd/openwrt.git
REPO_BRANCH=v22.03.5

FEEDS_CONF=feeds.conf.default
CONFIG_FILE=adslr_g7.config
DIY_SH_P1=diy-part1.sh
DIY_SH_P2=diy-part2.sh
UPLOAD_BIN_DIR=false
UPLOAD_FIRMWARE=true
UPLOAD_COWTRANSFER=false
UPLOAD_WETRANSFER=false
UPLOAD_RELEASE=false

# git clone https://gitee.com/mybsd/openwrt.git --depth 1 -b v22.03.5 openwrt
git clone $REPO_URL --depth 1 -b $REPO_BRANCH openwrt
        # ln -sf /workdir/openwrt $GITHUB_WORKSPACE/openwrt
        # git -C /workdir/openwrt checkout -b $REPO_BRANCH

cd openwrt

sed -i s#git.openwrt.org/feed/packages#gitee.com/mybsd/openwrt-packages#g feeds.conf.default
sed -i s#git.openwrt.org/project/luci#gitee.com/mybsd/openwrt-luci#g feeds.conf.default
sed -i s#git.openwrt.org/feed/routing#gitee.com/mybsd/openwrt-routing#g feeds.conf.default


echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall          https://github.com/xiaorouji/openwrt-passwall.git;main"          >> "feeds.conf.default"

sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        https://github.com/fw876/helloworld.git"                         >> "feeds.conf.default"

./scripts/feeds update -a
./scripts/feeds install -a

./scripts/feeds update helloworld
./scripts/feeds install -a -f -p helloworld


# $ find -name shadowsocks-rust
# ./feeds/helloworld/shadowsocks-rust
# ./feeds/passwall_packages/shadowsocks-rust
# ./package/feeds/helloworld/shadowsocks-rust


git apply $GITHUB_WORKSPACE/patches/*.diff
git apply $GITHUB_WORKSPACE/patches/*.ldiff


# ./scripts/feeds update packages

# For OpenWrt 21.02 or lower version
# You have to manually upgrade Golang toolchain to 1.19 or higher to compile Xray-core.
rm -rf feeds/packages/lang/golang
svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang


    git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
    git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb.git    package/lua-maxminddb
    git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr.git    package/luci-app-vssr


./scripts/feeds update helloworld
./scripts/feeds install -a -p helloworld

./scripts/feeds update passwall
./scripts/feeds install -a -p passwall

./scripts/feeds update passwall_packages
./scripts/feeds install -a -p passwall_packages



# sudo rsync -avh --remove-source-files --ignore-existing --progress \
# /mnt/e/openwrt/build_openwrt/ \
#  /build_openwrt/ 
 
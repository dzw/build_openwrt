#!/bin/bash

# 由于 WSL 的 PATH 中包含带有空格的 Windows 路径，有可能会导致编译失败，请在 make 前面加上：
# find: The relative path 'Files/WindowsApps/MicrosoftCorporationII.WindowsSubsystemForLinux_1.2.5.0_x64__8wekyb3d8bbwe' is included in the PATH environment variable, which is insecure in combination with the -execdir action of find.  Please remove that entry from $PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/snap/bin


# 一行一个写入 script/localmirrors
# 以分号隔开, CONFIG_LOCALMIRROR=URI 写入 .config
# 以分号隔开, 设置环境变量 DOWNLOAD_MIRROR
# CONFIG_LOCALMIRROR="https://openwrt.ecoo.top/files/openwrtdl"
# CONFIG_LOCALMIRROR="file:///home/username/mirror

# https://blog.csdn.net/u014436243/article/details/103906937/
# 执行make menuconfig并且设置“Target System","Subtarget","Target Profile";
# 执行make defconfig;
# 执行make menuconfig并且修改设置包；
# 执行scripts/diffconfig.sh >mydiffconfig,存储你的改变到文本文件mydiffconfig中；
# 执行make download(在最终make之前下载所有的依赖文件，并且使多核编译可用）
# 执行make V=s（编译OpenWrt并且在控制台打印日志，你可以看到你在哪失败了)

GITHUB_WORKSPACE=/home/dzw/build_openwrt/

sudo apt install ncurses-dev pkg-config

REPO_URL=https://github.com/coolsnowwolf/lede
REPO_URL=https://github.com/openwrt/openwrt.git
REPO_URL=https://git.nju.edu.cn/nju/openwrt.git
REPO_BRANCH=openwrt-21.02

FEEDS_CONF=feeds.conf.default
CONFIG_FILE=adslr_g7.config
DIY_SH_P1=diy-part1.sh
DIY_SH_P2=diy-part2.sh
UPLOAD_BIN_DIR=false
UPLOAD_FIRMWARE=true
UPLOAD_COWTRANSFER=false
UPLOAD_WETRANSFER=false
UPLOAD_RELEASE=false

#v21.02.7 WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist

# git clone https://gitee.com/mybsd/openwrt.git    --depth 1 -b v22.03.5 openwrt
# echo git clone https://github.com/openwrt/openwrt.git --depth 1 -b openwrt-22.03 openwrt

# git clone https://gitee.com/mybsd/openwrt.git --depth 1 -b openwrt-21.02 openwrt
# git clone https://git.nju.edu.cn/nju/openwrt.git --depth 1 -b openwrt-21.02 openwrt
# git clone https://git.nju.edu.cn/nju/openwrt.git --depth 1 -b v21.02.7 openwrt


git clone $REPO_URL --depth 1 -b $REPO_BRANCH openwrt
        # ln -sf /workdir/openwrt $GITHUB_WORKSPACE/openwrt
        # git -C /workdir/openwrt checkout -b $REPO_BRANCH

OPENWRT_ROOT=$GITHUB_WORKSPACE/openwrt
OPENWRT_ROOT=$GITHUB_WORKSPACE/lede

cd $OPENWRT_ROOT
mv build_dir /mnt/e/openwrt/
mv bin       /mnt/e/openwrt/

# mkdir /mnt/e/openwrt/
# mv dl /mnt/e/openwrt/
# ln -s /mnt/e/openwrt/dl         dl

ln -s /mnt/e/openwrt/bin/       bin
ln -s /mnt/e/openwrt/build_dir/ build_dir

git clone git@gitee.com:kwill/openwrt-dependent-dl.git dl

# sed -i s#git.openwrt.org/feed/packages#gitee.com/mybsd/openwrt-packages#g feeds.conf.default
# sed -i s#git.openwrt.org/project/luci#gitee.com/mybsd/openwrt-luci#g feeds.conf.default
# sed -i s#git.openwrt.org/feed/routing#gitee.com/mybsd/openwrt-routing#g feeds.conf.default

# [Pass Wall] 顯示菜單
# WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall          https://github.com/xiaorouji/openwrt-passwall.git;main"          >> "feeds.conf.default"

# [ShadowSocksR Plus+] 顯示菜單
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        https://github.com/fw876/helloworld.git"                         >> "feeds.conf.default"

# root@OpenWrt:~# opkg install xray-core
# Installing xray-core (1.8.3-1) to root...
# Collected errors:
#  * verify_pkg_installable: Only have 4176kb available on filesystem /overlay, pkg xray-core needs 7987
#  * opkg_install_cmd: Cannot install package xray-core.

# $ find -name shadowsocks-rust
# ./feeds/helloworld/shadowsocks-rust
# ./feeds/passwall_packages/shadowsocks-rust
# ./package/feeds/helloworld/shadowsocks-rust

cd $OPENWRT_ROOT

git apply ../patches/v22.03.5.diff
git apply $GITHUB_WORKSPACE/patches/*.diff
# git apply $GITHUB_WORKSPACE/patches/*.ldiff

git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

#[Hello World] 顯示菜單 節點導入失敗
# WARNING: Makefile 'package/lean/luci-app-vssr/Makefile' has a dependency on 'pdnsd-alt', which does not exist
# git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr.git    package/lean/luci-app-vssr
# git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb.git    package/lean/lua-maxminddb

# ./scripts/feeds update helloworld
# ./scripts/feeds update passwall
# ./scripts/feeds update passwall_packages

# ./scripts/feeds install -a -f -p helloworld
# ./scripts/feeds install -a -p helloworld
# ./scripts/feeds install -a -p passwall
# ./scripts/feeds install -a -p passwall_packages

chmod +x ./scripts/feeds

./scripts/feeds update -a

# For OpenWrt 21.02 or lower version
# You have to manually upgrade Golang toolchain to 1.19 or higher to compile Xray-core.
rm -rf feeds/packages/lang/golang 
# svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang
svn export https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang

./scripts/feeds install -a


# set FORCE_UNSAFE_CONFIGURE=1

cd $OPENWRT_ROOT
rm -rf tmp
# make defconfig
make menuconfig
make download -j8

make -j1 V=s

# no Go files in build_dir v2ray-plugin-5.8.0/.go_work/build
# \\wsl.localhost\Ubuntu-18.04/\home\dzw\build_openwrt\openwrt\build_dir\target-mipsel_24kc_musl\v2ray-plugin-5.8.0\.go_work\build\src

find dl -size -1024c -exec ls -l {} \;
make -j$(nproc) || make -j1 || make -j1 V=s

# sudo rsync -avh --remove-source-files --ignore-existing --progress \
# /mnt/e/openwrt/build_openwrt/ \
#  /build_openwrt/


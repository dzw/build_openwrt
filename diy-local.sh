#!/bin/bash



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

cd /build_openwrt/openwrt
mv build_dir /mnt/e/openwrt/
mv bin       /mnt/e/openwrt/
ln -s /mnt/e/openwrt/bin/       bin
ln -s /mnt/e/openwrt/build_dir/ build_dir

git clone git@gitee.com:kwill/openwrt-dependent-dl.git dl

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


PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/snap/bin




# sudo rsync -avh --remove-source-files --ignore-existing --progress \
# /mnt/e/openwrt/build_openwrt/ \
#  /build_openwrt/

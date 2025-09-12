#!/bin/bash
GITHUB_WORKSPACE=/home/dzw/build_openwrt/

# OPENWRT_ROOT=$GITHUB_WORKSPACE/lede
OPENWRT_ROOT=$GITHUB_WORKSPACE/openwrt

# REPO_URL=https://github.com/coolsnowwolf/lede
# REPO_URL=https://git.nju.edu.cn/nju/openwrt.git
REPO_URL=https://github.com/openwrt/openwrt.git


# 由于 WSL 的 PATH 中包含带有空格的 Windows 路径，有可能会导致编译失败，请在 make 前面加上：
# find: The relative path 'Files/WindowsApps/MicrosoftCorporationII.WindowsSubsystemForLinux_1.2.5.0_x64__8wekyb3d8bbwe' is included in the PATH environment variable, which is insecure in combination with the -execdir action of find.  Please remove that entry from $PATH
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

sudo apt update
sudo apt install -y ncurses-dev pkg-config
# sudo apt install -y build-essential bzip2 ccache curl ecj fastjar file flex g++ gawk gettext git gperf libbz2-dev libffi-dev 
# libreadline-dev libsqlite3-dev libssl-dev libtool patch 
# rsync subversion tk-dev unzip wget xz-utils zlib1g-dev 

bison build-essential file flex g++ gawk gcc gettext libncursesw5 libssl-dev make python3 python3-dev python3-distutils python3-pip python3-setuptools python3-stdlib python3-venv python3-wheel unzip wget zlib1g-dev 

sudo apt-get install build-essential ccache ncurses-dev zlib1g-dev gawk libssl-dev git subversion unzip python3
sudo apt install gcc-8 g++-8 gcc-9 g++-9 build-essential
sudo apt install swig python3-dev

sudo apt install zstd


sudo apt install -y  g++ python3


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

git config --global http.https://git.openwrt.org.proxy  http://192.168.124.160:10808
git config --global http.https://github.com.proxy       http://192.168.124.160:10808

REPO_BRANCH=v24.10.2
if [ ! -d $GITHUB_WORKSPACE/openwrt ]; then
    echo "clone openwrt"
    git clone $REPO_URL --depth 1 -b $REPO_BRANCH openwrt
else
    echo "openwrt already exists"
    git -C $OPENWRT_ROOT fetch --tags
    git -C $OPENWRT_ROOT reset --hard
    git -C $OPENWRT_ROOT checkout $REPO_BRANCH
fi

# mv build_dir /mnt/e/openwrt/
# mv bin       /mnt/e/openwrt/
# mkdir /mnt/e/openwrt/
# mv dl /mnt/e/openwrt/
# ln -s /mnt/e/openwrt/dl         dl
# ln -s /mnt/e/openwrt/bin/       bin
# ln -s /mnt/e/openwrt/build_dir/ build_dir
# git clone git@gitee.com:kwill/openwrt-dependent-dl.git dl


cd $OPENWRT_ROOT
export https_proxy=http://192.168.123.111:10808
wget https://downloads.openwrt.org/releases/24.10.2/targets/mediatek/filogic/config.buildinfo -O $OPENWRT_ROOT/.config
wget https://downloads.openwrt.org/releases/24.10.2/targets/mediatek/filogic/feeds.buildinfo  -O $OPENWRT_ROOT/feeds.conf.default
unset http_proxy

# bash "$DIY_SH_P1"
# bash $GITHUB_WORKSPACE/addfeed_passwall.sh
bash $GITHUB_WORKSPACE/addfeed_ssrp.sh

# root@OpenWrt:~# opkg install xray-core
# Installing xray-core (1.8.3-1) to root...
# Collected errors:
#  * verify_pkg_installable: Only have 4176kb available on filesystem /overlay, pkg xray-core needs 7987
#  * opkg_install_cmd: Cannot install package xray-core.

# $ find -name shadowsocks-rust
# ./feeds/helloworld/shadowsocks-rust
# ./feeds/passwall_packages/shadowsocks-rust
# ./package/feeds/helloworld/shadowsocks-rust


# git apply ../patches/v22.03.5.diff
# git apply $GITHUB_WORKSPACE/patches/*.diff
# git apply $GITHUB_WORKSPACE/patches/*.ldiff

# git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# ./scripts/feeds update helloworld
# ./scripts/feeds update passwall_luci
# ./scripts/feeds update passwall_packages
# ./scripts/feeds install -a -f -p helloworld
# ./scripts/feeds install -a -p helloworld
# ./scripts/feeds install -a -p passwall_luci
# ./scripts/feeds install -a -p passwall_packages
# chmod +x ./scripts/feeds
# ./scripts/feeds uninstall helloworld
# ./scripts/feeds uninstall passwall_luci
# ./scripts/feeds uninstall passwall_packages
./scripts/feeds update  -a
./scripts/feeds install -a


# # For OpenWrt 21.02 or lower version
# # You have to manually upgrade Golang toolchain to 1.19 or higher to compile Xray-core.
# rm -rf feeds/packages/lang/golang 
# # svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang
# # svn export https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang



# CMake 3.31 or higher is required. You are running version 3.30.5
tar -xzf cmake-3.31.8.tar.gz
cd cmake-3.31.8 
./bootstrap --prefix=/usr/local  # Or your preferred prefix
make -j$(nproc)
sudo make install


# set FORCE_UNSAFE_CONFIGURE=1
cd $OPENWRT_ROOT
rm -rf tmp
# make defconfig
make menuconfig

export https_proxy=http://192.168.123.111:10808
# make download -j8
make download -j1 V=s
unset http_proxy

make -j1 V=s

# no Go files in build_dir v2ray-plugin-5.8.0/.go_work/build
# \\wsl.localhost\Ubuntu-18.04/\home\dzw\build_openwrt\openwrt\build_dir\target-mipsel_24kc_musl\v2ray-plugin-5.8.0\.go_work\build\src

find dl -size -1024c -exec ls -l {} \;

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/snap/bin
make -j$(nproc) || make -j1 || make -j1 V=sc


#find . -type f -name '*[Mm]akefile*' -exec grep -l -E -- '(-lpcre|libpcre)' {} +

#sed libpcre/libpcre2  package\feeds\helloworld\shadowsocksr-libev\Makefile 

# find . -name "Makefile*" -exec grep -l "bb40f027fef8534b0f905a827dbc3cc613fd06b705392148a12b80e1f9570a88" {} \;



# sudo rsync -avh --remove-source-files --ignore-existing --progress \
# /mnt/e/openwrt/build_openwrt/ \
#  /build_openwrt/


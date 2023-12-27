GITHUB_WORKSPACE=~/build_openwrt
REPO_BRANCH=v23.05.0

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

git -C $GITHUB_WORKSPACE/openwrt checkout -b $REPO_BRANCH



git checkout tags/v22.03.6 -b v22.03.6
git branch -d v22.03.6
git branch -D v22.03.6
git branch -m v22.03.6_ 22.03.6
git status

# $GITHUB_WORKSPACE/diy-part1.sh

# hysteria: update to 2.1.1
# echo "src-git helloworld        https://github.com/dzw/ssrp.git^cbaf9ad7cdcf55ff2d54c12ef4ea218e3e36f225" >> "feeds.conf.default"

# [Pass Wall] 顯示菜單
# WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall          https://github.com/xiaorouji/openwrt-passwall.git;main"          >> "feeds.conf.default"


        # [ShadowSocksR Plus+] 顯示菜單

        # v2ray-core: update to 5.10.0
        sed -i "/helloworld/d" "feeds.conf.default"  #mosdns 導致胞體太大
        echo "src-git helloworld        https://github.com/dzw/ssrp.git^a33d777e866e537a72472d8b90ebbb1cb434c746" >> "feeds.conf.default"

export https_proxy=http://192.168.1.235:10809
        ./scripts/feeds update -a
        ./scripts/feeds install -a                #導致重新編譯

./scripts/feeds update hellowrld

./scripts/feeds install passwall_packages #單獨安裝避免重新編譯
./scripts/feeds install passwall          #單獨安裝避免重新編譯
./scripts/feeds install hellowrld         #單獨安裝避免重新編譯

# ./scripts/feeds uninstall helloworld
# rm -rf ./package/feeds/packages/xray-core

./scripts/feeds uninstall passwall
./scripts/feeds uninstall passwall_packages

./scripts/feeds uninstall xray-core 
./scripts/feeds install -p passwall_packages xray-core

# ls ./package/feeds/passwall_packages/xray-core -l
## ./package/feeds/passwall_packages/xray-core -> ../../../feeds/passwall_packages/xray-core
# make  ./package/feeds/passwall_packages/xray-core/compile

# ls ./package/feeds/packages/xray-core

rm -rf feeds/packages/lang/golang 
# svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang
# svn export https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

# wget https://downloads.openwrt.org/releases/22.03.5/targets/ramips/mt76x8/config.buildinfo -O .config
# wget https://downloads.openwrt.org/releases/22.03.6/targets/ramips/mt7621/config.buildinfo -O .config

git apply $GITHUB_WORKSPACE/patches/$REPO_BRANCH.diff
# $GITHUB_WORKSPACE/diy-part2.sh

CONFIG_FILE=22.03.5_mt300n-v2.config
CONFIG_FILE=22.03.5_k2_224x5_ssrp.config
CONFIG_FILE=22.03.5_k2_224x5_passwall.config
CONFIG_FILE=22.03.5_k2_224x5_def.config
CONFIG_FILE=config.buildinfo_mt7620_23.05.0
CONFIG_FILE=config.buildinfo_mt7621_22.03.5
[ -e ../$CONFIG_FILE ] && cp ../$CONFIG_FILE ./.config


# Collected errors:
#  * check_data_file_clashes: Package px5g-wolfssl wants to install file /home/dzw/build_openwrt/openwrt/build_dir/target-mipsel_24kc_musl/root-ramips/usr/sbin/px5g
#         But that file is already provided by package  * px5g-mbedtls
#  * opkg_install_cmd: Cannot install package px5g-wolfssl.
# px5g-wolfssl
# px5g-mbedtls


make menuconfig

make defconfig

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
make download -j8
# git config --global --add safe.directory /home/dzw/build_openwrt/openwrt

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
make -j8 || make -j1 V=s


# k2-v22.4
#     0xfb0000-0x50000= 16121856/1024  =15744k           
#     0x7b0000-0x50000= 7733248/1024  =7552k           mk 7872k

# k2-v22.5 0xfb0000-0xa0000= 15794176/1024  =15424k
#          0x760000-0xa0000=  7077888/1024  =6912k     mk 7552k

# 300n 0xfb0000-0x50000= 16121856/1024= 15744k      mk 16064k


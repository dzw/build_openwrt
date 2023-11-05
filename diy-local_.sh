GITHUB_WORKSPACE=~/build_openwrt
REPO_BRANCH=v23.05.0

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

git -C $GITHUB_WORKSPACE/openwrt checkout -b $REPO_BRANCH

# $GITHUB_WORKSPACE/diy-part1.sh

# [Pass Wall] 顯示菜單
# WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall          https://github.com/xiaorouji/openwrt-passwall.git;main"          >> "feeds.conf.default"

# [ShadowSocksR Plus+] 顯示菜單
sed -i "/helloworld/d" "feeds.conf.default"  #mosdns 導致胞體太大
# v2ray-core: update to 5.10.0
echo "src-git helloworld        https://github.com/dzw/ssrp.git^a33d777e866e537a72472d8b90ebbb1cb434c746" >> "feeds.conf.default"
# hysteria: update to 2.1.1
# echo "src-git helloworld        https://github.com/dzw/ssrp.git^cbaf9ad7cdcf55ff2d54c12ef4ea218e3e36f225" >> "feeds.conf.default"

./scripts/feeds update hellowrld
# ./scripts/feeds uninstall helloworld

./scripts/feeds update -a

./scripts/feeds install -a

# rm -rf ./package/feeds/packages/xray-core

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
CONFIG_FILE=22.03.5_mt300n-v2.config

CONFIG_FILE=22.03.5_k2_224x5_ssrp.config

CONFIG_FILE=22.03.5_k2_224x5_passwall.config

CONFIG_FILE=22.03.5_k2_224x5_def.config

CONFIG_FILE=config.buildinfo_mt7620_23.05.0
[ -e ../$CONFIG_FILE ] && cp ../$CONFIG_FILE ./.config

git apply $GITHUB_WORKSPACE/patches/$REPO_BRANCH.diff

# $GITHUB_WORKSPACE/diy-part2.sh
make menuconfig

make defconfig

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
make download -j8
# git config --global --add safe.directory /home/dzw/build_openwrt/openwrt
make -j8 || make -j1 V=s


# k2-v22.4
#     0xfb0000-0x50000= 16121856/1024  =15744k           
#     0x7b0000-0x50000= 7733248/1024  =7552k           mk 7872k

# k2-v22.5 0xfb0000-0xa0000= 15794176/1024  =15424k
#          0x760000-0xa0000=  7077888/1024  =6912k     mk 7552k

# 300n 0xfb0000-0x50000= 16121856/1024= 15744k      mk 16064k


CONFIG_FILE=22.03.5_k2.config
CONFIG_FILE=22.03.5_mt300n-v2.config

GITHUB_WORKSPACE=~/build_openwrt



git -C $GITHUB_WORKSPACE/openwrt checkout -b $REPO_BRANCH

# $GITHUB_WORKSPACE/diy-part1.sh

# # [Pass Wall] 顯示菜單
# # WARNING: Makefile 'package/feeds/passwall_packages/sing-box/Makefile' has a dependency on 'kmod-inet-diag', which does not exist
# echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
# echo "src-git passwall          https://github.com/xiaorouji/openwrt-passwall.git;main"          >> "feeds.conf.default"

# # [ShadowSocksR Plus+] 顯示菜單
# sed -i "/helloworld/d" "feeds.conf.default"
# echo "src-git helloworld        https://github.com/fw876/helloworld.git"                         >> "feeds.conf.default"


./scripts/feeds update -a
./scripts/feeds install -a

[ -e ../$CONFIG_FILE ] && cp ../$CONFIG_FILE ./.config

# $GITHUB_WORKSPACE/diy-part2.sh

make defconfig
make download -j8

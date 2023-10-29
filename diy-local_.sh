GITHUB_WORKSPACE=~/build_openwrt

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

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

# rm -rf ./package/feeds/packages/xray-core

./scripts/feeds uninstall xray-core && ./scripts/feeds install -p passwall_packages xray-core

# ls ./package/feeds/passwall_packages/xray-core -l
## ./package/feeds/passwall_packages/xray-core -> ../../../feeds/passwall_packages/xray-core
# make  ./package/feeds/passwall_packages/xray-core/compile


# ls ./package/feeds/packages/xray-core

rm -rf feeds/packages/lang/golang 
svn export https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang
# svn export https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

CONFIG_FILE=22.03.5_mt300n-v2.config
CONFIG_FILE=22.03.5_psg1218.config
CONFIG_FILE=22.03.5_k2_224x5.config
[ -e ../$CONFIG_FILE ] && cp ../$CONFIG_FILE ./.config


# $GITHUB_WORKSPACE/diy-part2.sh
make menuconfig

make defconfig
make download -j8

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
make -j8 || make -j1 V=s


# k2-v22.4
#     0xfb0000-0x50000= 16121856/1024  =15744k           
#     0x7b0000-0x50000= 7733248/1024  =7552k           mk 7872k

# k2-v22.5 0xfb0000-0xa0000= 15794176/1024  =15424k
#          0x760000-0xa0000=  7077888/1024  =6912k     mk 7552k

# 300n 0xfb0000-0x50000= 16121856/1024= 15744k      mk 16064k


dhcp.sh 没有执行权限导致 "Unsupported protocol type" wan "DHCP Client"不显示

ls -l build_dir/target-mipsel_24kc_musl/netifd-2022-08-25-76d2d41b/.pkgdir/netifd/lib/netifd/proto/dhcp.sh
ls -l build_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcp.sh
ls -l build_dir/target-mipsel_24kc_musl/root.orig-ramips/lib/netifd/proto/dhcp.sh
ls -l package/network/config/netifd/files/lib/netifd/proto/dhcp.sh
ls -l staging_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcp.sh

find . -type f -name *.sh -exec ls -l {} \;
find . -type f -name *.sh -exec chmod a=rwx {} \;

find . -type dhcp.sh -exec ls -l {} \;
find . -name dhcp.sh


root@OpenWrt:/lib# chmod +x /lib/netifd/proto/*.sh


dzw@dzw-PC:~/build_openwrt/openwrt$ find . -name dhcp.sh -exec ls -l {} \;
-rw-r--r-- 1 dzw dzw 2875 Apr  3  2023 ./build_dir/target-mipsel_24kc_musl/root.orig-ramips/lib/netifd/proto/dhcp.sh
-rw-r--r-- 1 dzw dzw 2875 Apr 28  2023 ./build_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcp.sh
-rwxr-xr-x 1 dzw dzw 2875 Oct 22 21:03 ./build_dir/target-mipsel_24kc_musl/netifd-2022-08-25-76d2d41b/.pkgdir/netifd/lib/netifd/proto/dhcp.sh
-rwxr-xr-x 1 dzw dzw 2875 Oct 22 21:03 ./package/network/config/netifd/files/lib/netifd/proto/dhcp.sh
-rwxr-xr-x 1 dzw dzw 2875 Oct 22 21:03 ./staging_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcp.sh
dzw@dzw-PC:~/build_openwrt/openwrt$ find . -name dhcpv6.sh -exec ls -l {} \;
-rwxr-xr-x 1 dzw dzw 4902 Aug 18  2022 ./build_dir/target-mipsel_24kc_musl/root.orig-ramips/lib/netifd/proto/dhcpv6.sh
-rwxr-xr-x 1 dzw dzw 4902 Apr 28  2023 ./build_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcpv6.sh
-rwxr-xr-x 1 dzw dzw 4902 Oct 29 20:38 ./build_dir/target-mipsel_24kc_musl/odhcp6c-2022-08-05-7d21e8d8/.pkgdir/odhcp6c/lib/netifd/proto/dhcpv6.sh
-rwxrwxrwx 1 dzw dzw 4902 Jan 21  2023 ./package/network/ipv6/odhcp6c/files/dhcpv6.sh
-rwxr-xr-x 1 dzw dzw 4902 Oct 29 20:38 ./staging_dir/target-mipsel_24kc_musl/root-ramips/lib/netifd/proto/dhcpv6.sh

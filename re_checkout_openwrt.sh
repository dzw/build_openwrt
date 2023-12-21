cd ~/build_openwrt/

mv openwrt/dl        mv  ./bak_dl
mv openwrt/.git      mv  ./bak_.git
mv openwrt/feeds     mv  ./bak_feeds

rmdir openwrt
mkdir openwrt

mv ./bak_dl     mkdir /dl
mv ./bak_.git   openwrt/.git
mv ./bak_feeds  openwrt/feeds

cd openwrt
git checkout v22.03.5

git reset
git clean -fd
git checkout .


sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld        https://github.com/dzw/ssrp.git^a33d777e866e537a72472d8b90ebbb1cb434c746" >> "feeds.conf.default"

./scripts/feeds update -a
./scripts/feeds install -a  
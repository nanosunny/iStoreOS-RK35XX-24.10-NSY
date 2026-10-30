#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
# sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
# sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
# cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/


# 追加自定义内核配置项 
echo "CONFIG_PSI=y
CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/config-6.12

# 动态探测内核版本 暂时不用
# KVER=$(ls target/linux/rockchip/armv8/ | grep -oE 'config-[0-9]+\.[0-9]+' | head -1)
# echo "CONFIG_PSI=y
# CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/${KVER}


# 集成CPU性能跑分脚本
# cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64 package/base-files/files/bin/coremark-arm64
# cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64.sh package/base-files/files/bin/coremark.sh
# chmod 755 package/base-files/files/bin/coremark-arm64
# chmod 755 package/base-files/files/bin/coremark.sh


# iStoreOS-settings
# git clone --depth=1 -b main https://github.com/nanosunny/istoreos-settings package/default-settings


# 定时限速插件
# git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus

# 20261030-16:00 修改
define Device/rk3568
  SOC := rk3568
  UBOOT_DEVICE_NAME := easepi-rk3568    # 使用 easepi-rk3568 的 U-Boot
  IMAGE/sysupgrade.img.gz := boot-common | boot-script rk3568 | pine64-img | gzip | append-metadata
endef

# 20261030-16:00 修改
define Device/nsy_g68-plus
  $(call Device/rk3568)
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68
  DEVICE_DTS := rk3568/rk3568-nsy-g68-plus
  DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-net-dsa-realtek kmod-r8169 kmod-mt7916-firmware
endef
TARGET_DEVICES += nsy_g68-plus


# 增加nsy_g68-plus 20261030-16:00 修改关闭
#echo -e "\\ndefine Device/nsy_g68-plus
#\$(call Device/Legacy/rk3568,\$(1))
#  DEVICE_VENDOR := NSY
#  DEVICE_MODEL := G68
#  DEVICE_DTS := rk3568/rk3568-nsy-g68-plus
#  DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-net-dsa-realtek kmod-r8169 kmod-mt7916-firmware
  # DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-switch-rtl8367b swconfig kmod-swconfig kmod-r8169 kmod-mt7916-firmware
#endef
#TARGET_DEVICES += nsy_g68-plus" >> target/linux/rockchip/image/legacy.mk


# 增加nsy_g16-plus
# echo -e "\\ndefine Device/nsy_g16-plus
# \$(call Device/Legacy/rk3568,\$(1))
#   DEVICE_VENDOR := NSY
#   DEVICE_MODEL := G16
#   DEVICE_DTS := rk3568/rk3568-nsy-g16-plus
#   DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-switch-rtl8367b swconfig kmod-swconfig kmod-r8169 kmod-mt7615-firmware
# endef
# TARGET_DEVICES += nsy_g16-plus" >> target/linux/rockchip/image/legacy.mk


# 增加bdy_g18-pro
# echo -e "\\ndefine Device/bdy_g18-pro
# \$(call Device/Legacy/rk3568,\$(1))
#   DEVICE_VENDOR := BDY
#   DEVICE_MODEL := G18
#   DEVICE_DTS := rk3568/rk3568-bdy-g18-pro
#   DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-switch-rtl8367b swconfig kmod-swconfig kmod-r8169 kmod-mt7615-firmware
# endef
# TARGET_DEVICES += bdy_g18-pro" >> target/linux/rockchip/image/legacy.mk


# 复制 02_network 网络配置文件到 target/linux/rockchip/armv8/base-files/etc/board.d/ 目录下
cp -f $GITHUB_WORKSPACE/configfiles/02_network target/linux/rockchip/armv8/base-files/etc/board.d/02_network


# 加入初始化交换机脚本
#cp -f $GITHUB_WORKSPACE/configfiles/swconfig_install package/base-files/files/etc/init.d/swconfig_install
#chmod 755 package/base-files/files/etc/init.d/swconfig_install


# 集成 nsy_g68-plus WiFi驱动
mkdir -p package/base-files/files/lib/firmware/mediatek
cp -f $GITHUB_WORKSPACE/configfiles/WirelessDriver/mt7916_eeprom.bin package/base-files/files/lib/firmware/mediatek/mt7916_eeprom.bin
cp -f $GITHUB_WORKSPACE/configfiles/WirelessDriver/mt7916_eeprom_backup.bin package/base-files/files/lib/firmware/mediatek/mt7916_eeprom_backup.bin
cp -f $GITHUB_WORKSPACE/configfiles/opwifi package/base-files/files/etc/init.d/opwifi
chmod 755 package/base-files/files/etc/init.d/opwifi


# 电工大佬的rtl8367b驱动资源包，暂时使用这样替换 6.12主线已改用DSA
# wget https://github.com/nanosunny/files/releases/download/files/rtl8367b.tar.gz
# tar -xvf rtl8367b.tar.gz


# 复制dts设备树文件到指定目录下
cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3568/* target/linux/rockchip/dts/rk3568/
# cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3588/* target/linux/rockchip/dts/rk3588/


# ===== 修复 iStoreOS 25.12 apk 包冲突：nginx-ssl-util 覆盖 base-files =====
# 给 package install 阶段加 --force-overwrite
# find include/ package/ -maxdepth 3 -name "*.mk" -exec grep -l "apk add" {} \; 2>/dev/null | \
#    xargs -r sed -i 's|\bapk add \$(|apk add --force-overwrite $(|g; s|\bapk add --|apk add --force-overwrite --|g; s|\bapk add -|apk add --force-overwrite -|g'
# 兜底：设置 apk 全局默认强制覆盖（若存在 apk world/repositories 配置）
#grep -q "force-overwrite" package/system/opkg/Makefile 2>/dev/null || \
#    sed -i 's|--no-cache|--force-overwrite --no-cache|g' package/system/opkg/Makefile 2>/dev/null || true



# ===== 修复：阻止 feeds 版 nginx-ssl-util 覆盖 iStoreOS 自带的 nginx 配置 =====
# 1) 先删掉 nginx-util 包里那两个冲突文件的安装指令
#find feeds -path "*/nginx-util/Makefile" 2>/dev/null | while read mk; do
#    sed -i 's|^[^#]*etc/config/nginx[[:space:]]*\\||g; s|^[^#]*etc/nginx/uci.conf.template[[:space:]]*\\||g' "$mk"
    # 同时把这两个文件从 conffiles 里删
#    sed -i '/etc\/config\/nginx/d; /etc\/nginx\/uci.conf.template/d' "$mk"
#done
# 2) 若 feeds 里的包 Makefile 还有 CONFLICTS 字段，避免冲突检测
#find feeds -path "*/nginx-util/Makefile" -o -path "*/nginx/Makefile" 2>/dev/null | while read mk; do
#    # 追加一行给它标注成与 base-files 无冲突（可选）
#    grep -q "^CONFLICTS:=" "$mk" && echo 'CONFLICTS+= base-files' >> "$mk"
#done

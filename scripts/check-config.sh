#!/bin/bash
# 检查K2P配置完整性

CONFIG_FILE="${1:-.config}"

echo "🔍 检查K2P配置: $CONFIG_FILE"
echo "================================"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 配置文件不存在: $CONFIG_FILE"
    exit 1
fi

# 必需配置
required_configs=(
    "CONFIG_TARGET_ramips=y"
    "CONFIG_TARGET_ramips_mt7621=y"
    "CONFIG_TARGET_ramips_mt7621_DEVICE_phicomm_k2p=y"
    "CONFIG_TARGET_ROOTFS_SQUASHFS=y"
)

# 建议配置
recommended_configs=(
    "CONFIG_PACKAGE_kmod-mt7615e=y"
    "CONFIG_PACKAGE_kmod-mt7615-firmware=y"
    "CONFIG_PACKAGE_kmod-mt_wifi=y"
    "CONFIG_PACKAGE_wpad-openssl=y"
    "CONFIG_PACKAGE_dnsmasq=y"
    "CONFIG_PACKAGE_firewall=y"
)

# 检查必需配置
echo -e "\n必需配置检查:"
missing_required=0
for config in "${required_configs[@]}"; do
    key=$(echo "$config" | cut -d'=' -f1)
    if grep -q "^$config$" "$CONFIG_FILE"; then
        echo "✅ $key"
    else
        echo "❌ $key (缺少)"
        missing_required=1
    fi
done

# 检查建议配置
echo -e "\n建议配置检查:"
for config in "${recommended_configs[@]}"; do
    key=$(echo "$config" | cut -d'=' -f1)
    if grep -q "^$config$" "$CONFIG_FILE"; then
        echo "✅ $key"
    else
        echo "⚠️  $key (建议添加)"
    fi
done

# 检查文件系统大小
echo -e "\n文件系统配置:"
rootfs_size=$(grep "^CONFIG_TARGET_ROOTFS_PARTSIZE=" "$CONFIG_FILE" | cut -d'=' -f2 || echo "未设置")
if [ -n "$rootfs_size" ]; then
    echo "根分区大小: ${rootfs_size}MB"
    if [ "$rootfs_size" -lt 16 ]; then
        echo "⚠️  建议至少16MB"
    fi
else
    echo "❌ 未设置根分区大小"
fi

# 总结
echo -e "\n📊 配置检查总结:"
if [ $missing_required -eq 0 ]; then
    echo "✅ 必需配置完整"
else
    echo "❌ 缺少必需配置，构建可能失败"
    exit 1
fi

# 显示关键配置摘要
echo -e "\n关键配置摘要:"
grep -E "^CONFIG_TARGET|^CONFIG_PACKAGE_(kmod-mt|wpad|dnsmasq|firewall)" "$CONFIG_FILE" | sort

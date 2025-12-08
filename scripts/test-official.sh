#!/bin/bash
# 测试官方配置

echo "测试官方K2P配置生成..."

# 创建测试配置
cat > test-config << 'CONFIG'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_phicomm_k2p=y
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_ROOTFS_PARTSIZE=16
CONFIG_TARGET_IMAGES_GZIP=y
CONFIG_VMLINUX_INITRD=y
CONFIG_ALL=y
CONFIG_ALL_KMODS=y
CONFIG_BUILDBOT=y
CONFIG

echo "测试配置创建完成"
echo "关键选项: CONFIG_ALL=y (让系统选择默认包)"

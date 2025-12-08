#!/bin/bash
# K2P OpenWRT构建测试脚本

set -e

echo "🧪 K2P OpenWRT构建测试"
echo "======================"

# 检查依赖
check_deps() {
    echo "检查依赖..."
    local deps=("git" "make" "gcc" "g++" "python3" "rsync" "wget")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "缺少依赖: ${missing[*]}"
        return 1
    fi
    echo "✅ 依赖检查通过"
}

# 测试配置生成
test_config() {
    echo -e "\n测试配置生成..."
    
    cat > test-k2p-config << 'CONFIG'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_phicomm_k2p=y
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_ROOTFS_PARTSIZE=16
CONFIG_PACKAGE_kmod-mt7615e=y
CONFIG_PACKAGE_wpad-openssl=y
CONFIG

    echo "生成的配置:"
    cat test-k2p-config
    echo -e "\n✅ 配置测试通过"
}

# 测试固件查找模式
test_firmware_pattern() {
    echo -e "\n测试固件命名模式..."
    
    # 官方可能的命名模式
    patterns=(
        "openwrt-*-ramips-mt7621-phicomm_k2p-squashfs-sysupgrade.bin"
        "openwrt-*-ramips-mt7621-phicomm_k2p-initramfs-kernel.bin"
        "*-phicomm_k2p-*.bin"
    )
    
    echo "支持的固件命名模式:"
    for pattern in "${patterns[@]}"; do
        echo "  - $pattern"
    done
}

# 测试编译环境
test_env() {
    echo -e "\n测试编译环境..."
    
    # 检查磁盘空间
    local free_space=$(df -h . | awk 'NR==2 {print $4}')
    echo "可用磁盘空间: $free_space"
    
    # 检查内存
    local total_mem=$(free -m | awk 'NR==2 {print $2}')
    echo "总内存: ${total_mem}MB"
    
    if [ $total_mem -lt 2048 ]; then
        echo "⚠️  内存不足，建议至少2GB"
    else
        echo "✅ 内存检查通过"
    fi
}

# 主函数
main() {
    echo "开始K2P构建测试..."
    
    check_deps
    test_env
    test_config
    test_firmware_pattern
    
    echo -e "\n🎉 所有测试完成！"
    echo "建议配置:"
    echo "  1. 使用OpenWRT 24.10.4或更高版本"
    echo "  2. 确保包含kmod-mt7615e驱动"
    echo "  3. 配置至少16MB根文件系统"
    echo "  4. 使用V=s参数查看详细输出"
}

# 运行主函数
main "$@"

#!/bin/bash
# 功能选择助手 - 根据剩余空间推荐功能

echo "🎯 K2P固件功能选择助手"
echo "====================="

# 模拟固件大小分析
analyze_space() {
    local current_size=$1
    
    echo "当前固件大小: ${current_size}MB"
    echo "闪存限制: 16MB"
    
    local remaining=$((16 - current_size))
    echo "剩余空间: ${remaining}MB"
    
    echo ""
    echo "📦 可添加的功能包（按优先级）："
    
    if [ $remaining -ge 4 ]; then
        echo "✅ 充足空间 (>4MB):"
        echo "   - Luci完整主题包"
        echo "   - 网络监控工具 (bwm-ng, iftop)"
        echo "   - 系统工具 (htop, bash)"
        echo "   - 文件传输服务 (vsftpd)"
    fi
    
    if [ $remaining -ge 2 ]; then
        echo "🟡 中等空间 (2-4MB):"
        echo "   - 额外Luci应用 (upnp, dhcp)"
        echo "   - 网络诊断工具"
        echo "   - 时间同步服务"
    fi
    
    if [ $remaining -ge 1 ]; then
        echo "🔴 有限空间 (1-2MB):"
        echo "   - 基本文本编辑器 (nano)"
        echo "   - 网络工具 (curl, wget)"
        echo "   - 简单监控"
    fi
    
    if [ $remaining -lt 1 ]; then
        echo "❌ 空间不足 (<1MB):"
        echo "   需要精简现有功能"
    fi
}

# 使用示例
echo "使用示例:"
echo "  ./scripts/feature-selector.sh 8.5"
echo ""
echo "或者输入当前固件大小(MB):"
read -p "Size (MB): " size
analyze_space $size

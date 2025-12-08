#!/bin/bash
echo "⚙️ K2P配置文件管理器"
echo "==================="

echo "可用命令:"
echo "1. 查看配置摘要"
echo "2. 修复配置问题"
echo "3. 创建新配置"
echo "4. 验证所有配置"
echo ""

read -p "选择操作 (1-4): " choice

case $choice in
  1)
    echo "📊 配置摘要:"
    echo "============"
    for config in configs/k2p-*.config; do
      if [ -f "$config" ]; then
        name=$(basename "$config")
        packages=$(grep -c "^CONFIG_PACKAGE" "$config")
        size_estimate=$((packages * 100 + 5000))  # 粗略估算KB
        echo "$name:"
        echo "  包数量: $packages"
        echo "  估计大小: $((size_estimate/1000)).$((size_estimate%1000/100))MB"
        echo "  包含:"
        grep -E "luci|ddns|v2ray|adbyby" "$config" | sed 's/CONFIG_PACKAGE_//g' | head -3 | sed 's/^/    - /'
        echo ""
      fi
    done
    ;;
    
  2)
    echo "🔧 自动修复配置..."
    ./scripts/verify-config.sh
    echo ""
    echo "修复建议:"
    echo "1. 确保所有配置使用 dnsmasq-full"
    echo "2. 检查必需驱动: kmod-mt7615e"
    echo "3. 包数量控制在合理范围"
    ;;
    
  3)
    echo "📝 创建新配置"
    read -p "配置名称 (如: my-custom): " config_name
    if [ -n "$config_name" ]; then
      template="configs/k2p-final-recommended.config"
      if [ -f "$template" ]; then
        new_config="configs/k2p-${config_name}.config"
        cp "$template" "$new_config"
        echo "✅ 已创建: $new_config"
        echo "基于: $template"
        echo "包数量: $(grep -c '^CONFIG_PACKAGE' "$new_config")"
      else
        echo "❌ 模板文件不存在"
      fi
    fi
    ;;
    
  4)
    echo "✅ 验证所有配置..."
    ./scripts/verify-config.sh
    ;;
    
  *)
    echo "❌ 无效选择"
    ;;
esac

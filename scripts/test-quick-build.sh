#!/bin/bash
echo "🚀 K2P快速构建测试"
echo "===================="

echo "1. 检查配置文件冲突..."
CONFLICTS=0
for config in configs/k2p-*.config; do
  if [ -f "$config" ]; then
    dnsmasq_count=$(grep -c "CONFIG_PACKAGE_dnsmasq" "$config")
    if [ $dnsmasq_count -gt 1 ]; then
      echo "❌ $config: 存在多个dnsmasq配置"
      CONFLICTS=1
    fi
  fi
done

if [ $CONFLICTS -eq 0 ]; then
  echo "✅ 无配置文件冲突"
else
  echo "⚠️  发现配置冲突，需要修复"
fi

echo ""
echo "2. 推荐配置状态:"
RECOMMENDED="configs/k2p-final-recommended.config"
if [ -f "$RECOMMENDED" ]; then
  echo "✅ 最终推荐配置已创建"
  echo "   包数量: $(grep -c '^CONFIG_PACKAGE' "$RECOMMENDED")"
  echo "   包含功能:"
  grep -E "luci|ddns|vnstat|adbyby" "$RECOMMENDED" | sed 's/CONFIG_PACKAGE_//g' | head -5
else
  echo "❌ 推荐配置不存在"
fi

echo ""
echo "3. 工作流文件检查:"
if [ -f ".github/workflows/official-style.yml" ]; then
  echo "✅ 官方工作流文件存在"
  echo "   支持配置类型:"
  # 修复的grep命令
  sed -n '/options:/,/^[^[:space:]]/p' .github/workflows/official-style.yml | grep -E "^\s+-" | sed 's/.*- //g' | tr '\n' ' '
  echo ""
else
  echo "❌ 工作流文件不存在"
fi

echo ""
echo "4. 关键配置文件检查:"
ESSENTIAL_FILES=(
  "k2p-ultra-minimal.config"
  "k2p-final-recommended.config"
  "k2p-advanced.config"
  "k2p-stable.config"
)

for file in "${ESSENTIAL_FILES[@]}"; do
  if [ -f "configs/$file" ]; then
    echo "✅ $file 存在"
  else
    echo "❌ $file 缺失"
  fi
done

echo ""
echo "🎯 构建建议:"
echo "   🟢 首次测试: 使用 'final-recommended' 配置"
echo "   🟡 稳定运行: 使用 'stable' 配置"
echo "   🔵 最小化: 使用 'ultra-minimal' 配置"
echo "   🟣 功能完整: 使用 'advanced' 配置"
echo ""
echo "📊 预期固件大小:"
echo "   ultra-minimal: 5-7MB"
echo "   final-recommended: 10-12MB"
echo "   advanced: 12-15MB"
echo "   stable: 8-10MB"

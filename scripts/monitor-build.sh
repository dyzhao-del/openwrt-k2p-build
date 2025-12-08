#!/bin/bash
# K2P OpenWRT构建监控脚本

echo "📊 K2P OpenWRT构建监控"
echo "========================"

# 检查Git状态
echo "1. 检查Git状态:"
git status --short

# 显示最近提交
echo -e "\n2. 最近提交:"
git log --oneline -3

# 检查配置文件
echo -e "\n3. 配置文件检查:"
if [ -f "configs/k2p-minimal.config" ]; then
  echo "✅ k2p-minimal.config"
  echo "   目标设备: $(grep "DEVICE_phicomm_k2p" configs/k2p-minimal.config)"
  echo "   包数量: $(grep -c "^CONFIG_PACKAGE" configs/k2p-minimal.config)"
else
  echo "❌ k2p-minimal.config 不存在"
fi

if [ -f "configs/k2p-with-luci.config" ]; then
  echo "✅ k2p-with-luci.config"
  echo "   包含LuCI: $(grep -c "CONFIG_PACKAGE_luci" configs/k2p-with-luci.config)"
else
  echo "❌ k2p-with-luci.config 不存在"
fi

# 检查工作流文件
echo -e "\n4. 工作流文件检查:"
python3 check_yaml.py .github/workflows/official-style.yml 2>/dev/null
if [ $? -eq 0 ]; then
  echo "✅ official-style.yml 语法正确"
else
  echo "❌ official-style.yml 语法错误"
fi

# 显示构建指令
echo -e "\n5. 构建指令:"
echo "   最小配置: openwrt_version='v24.10.4', config_type='minimal'"
echo "   带LuCI:   openwrt_version='v24.10.4', config_type='with-luci'"

echo -e "\n✅ 准备就绪！"
echo "前往GitHub Actions运行构建。"

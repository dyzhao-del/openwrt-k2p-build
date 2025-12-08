#!/bin/bash
echo "🔍 配置文件验证脚本"
echo "===================="

check_config() {
  local config_file=$1
  echo "检查: $config_file"
  
  if [ ! -f "$config_file" ]; then
    echo "❌ 文件不存在"
    return 1
  fi
  
  # 检查dnsmasq冲突
  has_dnsmasq=$(grep -c "CONFIG_PACKAGE_dnsmasq=y" "$config_file")
  has_dnsmasq_full=$(grep -c "CONFIG_PACKAGE_dnsmasq-full=y" "$config_file")
  
  if [ $has_dnsmasq -gt 0 ] && [ $has_dnsmasq_full -gt 0 ]; then
    echo "❌ 存在dnsmasq冲突: 同时包含dnsmasq和dnsmasq-full"
    return 1
  elif [ $has_dnsmasq_full -gt 0 ]; then
    echo "✅ 使用dnsmasq-full (推荐)"
  elif [ $has_dnsmasq -gt 0 ]; then
    echo "⚠️  使用dnsmasq (基础版)"
  else
    echo "❌ 未包含DNS服务器"
    return 1
  fi
  
  # 检查必需配置
  REQUIRED=(
    "CONFIG_TARGET_ramips_mt7621_DEVICE_phicomm_k2p=y"
    "CONFIG_PACKAGE_kmod-mt7615e=y"
    "CONFIG_PACKAGE_firewall=y"
  )
  
  echo "必需配置检查:"
  for config in "${REQUIRED[@]}"; do
    if grep -q "^$config" "$config_file"; then
      echo "  ✅ $(echo $config | cut -d'=' -f1)"
    else
      echo "  ❌ $(echo $config | cut -d'=' -f1)"
    fi
  done
  
  # 统计
  total_packages=$(grep -c "^CONFIG_PACKAGE" "$config_file")
  echo "总包数: $total_packages"
  
  return 0
}

echo "验证所有配置文件:"
echo ""
for config in configs/k2p-*.config; do
  if [ -f "$config" ]; then
    check_config "$config"
    echo ""
  fi
done

echo "✅ 验证完成"
echo ""
echo "建议:"
echo "1. 所有配置应使用 dnsmasq-full 而不是 dnsmasq"
echo "2. 确保包含必要的K2P驱动"
echo "3. 包数控制在合理范围（建议<100）"

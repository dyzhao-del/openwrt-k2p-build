#!/bin/bash
# 固件大小优化工具

echo "🔧 K2P固件大小优化助手"
echo "======================"

echo "当前问题：固件16.8MB > 16MB限制"
echo ""
echo "优化策略："
echo "1. 移除非核心功能"
echo "2. 选择轻量级替代"
echo "3. 禁用可选组件"
echo ""

echo "📦 可移除/替换的组件（按节省空间排序）："
echo "========================================"

cat << 'SIZE_GUIDE'
1. Luci SSL支持 (-0.5MB)
   - 禁用: CONFIG_PACKAGE_luci-ssl
   - 影响: 只能HTTP访问，非HTTPS

2. 完整Luci主题 (-0.3MB)
   - 使用最小主题
   - 影响: 界面简化

3. 重复的网络工具 (-0.2MB)
   - 选择 curl 或 wget (二选一)
   - 选择 nano 或 vim (二选一)

4. 非核心Luci应用 (-0.1-0.5MB each)
   - luci-app-opkg (可通过SSH替代)
   - luci-app-commands
   - luci-app-filetransfer

5. 大型系统工具 (-0.3-1MB)
   - bash (用busybox ash替代)
   - htop (用top替代)
   - vim (用nano替代)

6. 可选服务 (-0.2-0.5MB)
   - SFTP服务器
   - NTP客户端
   - UPnP服务
SIZE_GUIDE

echo ""
echo "💡 建议操作顺序："
echo "1. 先禁用 luci-ssl (节省0.5MB)"
echo "2. 移除重复工具 (节省0.2MB)"
echo "3. 禁用非核心Luci应用 (节省0.3MB)"
echo "4. 检查是否需要所有内核模块"
echo ""
echo "预计可节省：1.0-1.5MB"
echo "目标大小：15.5MB以下"

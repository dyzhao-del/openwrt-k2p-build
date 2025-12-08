#!/bin/bash
# 测试K2P OpenWRT插件功能

echo "🔍 K2P插件功能测试"
echo "===================="

echo "1. LuCI界面检查："
echo "   [ ] 访问 http://192.168.1.1"
echo "   [ ] 中文界面显示正常"
echo "   [ ] 所有菜单可访问"

echo -e "\n2. DDNS功能测试："
echo "   [ ] DDNS配置界面"
echo "   [ ] 支持阿里云/CloudFlare"
echo "   [ ] 域名解析更新"

echo -e "\n3. 流量监控："
echo "   [ ] vnstat安装正常"
echo "   [ ] LuCI界面显示流量图表"
echo "   [ ] 实时流量统计"

echo -e "\n4. 广告屏蔽："
echo "   [ ] Adbyby配置界面"
echo "   [ ] 广告规则更新"
echo "   [ ] 实际过滤效果"

echo -e "\n5. 网络功能："
echo "   [ ] UPnP自动端口转发"
echo "   [ ] QoS流量控制"
echo "   [ ] 防火墙规则"

echo -e "\n6. 系统工具："
echo "   [ ] htop进程查看"
echo "   [ ] 文件传输(SFTP)"
echo "   [ ] 网络诊断工具"

echo -e "\n📋 测试命令："
cat << 'CMD'
# 检查服务状态
service list
ps | grep -E "(ddns|vnstat|adbyby)"

# 测试LuCI
opkg list-installed | grep luci

# 检查插件
ls /usr/lib/lua/luci/controller/

# 测试DDNS
cat /etc/ddns/services
CMD

echo -e "\n✅ 完成所有测试后，固件即可投入使用。"

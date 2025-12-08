# K2P OpenWRT 配置指南

## 可用配置类型

### 1. minimal (最小配置)
- 基础路由功能
- 无线驱动
- 无Web界面
- 适合开发者或极简用户

### 2. basic-enhanced (基础增强版) ★推荐★
- 完整LuCI中文界面
- DDNS动态域名
- 流量监控(vnstat)
- 广告屏蔽(Adbyby)
- 系统监控工具
- 适合家庭日常使用

### 3. advanced (高级功能版)
- 科学上网(v2ray/ssr)
- 智能DNS(smartdns)
- 内网穿透(frpc/frps)
- QoS流量控制
- 更多主题和插件
- 适合进阶用户

### 4. stable (精简稳定版)
- 基础LuCI界面
- DDNS支持
- 基本流量监控
- 移除实验性功能
- 适合长期稳定运行

## 插件功能说明

### 网络相关
- **DDNS**: 动态域名解析，支持阿里云、CloudFlare
- **vnstat**: 流量统计和监控
- **QoS**: 网络流量控制和优先级
- **UPnP**: 自动端口转发

### 安全和隐私
- **Adbyby**: 广告屏蔽
- **KoolproxyR**: 更强的广告过滤
- **科学上网**: v2ray/xray/shadowsocks

### 系统工具
- **htop**: 进程监控
- **nano**: 文本编辑器
- **curl/wget**: 下载工具
- **tcpdump**: 网络抓包

### 界面美化
- **Material主题**: 现代化界面
- **Bootstrap主题**: 经典界面

## 构建建议

1. **首次测试**: 使用 `basic-enhanced` 配置
2. **日常使用**: `basic-enhanced` 或 `stable`
3. **功能探索**: `advanced` 配置
4. **内存限制**: K2P有128MB内存，避免加载过多插件

## 自定义配置

你可以基于现有配置进行修改：
```bash
# 复制配置
cp configs/k2p-basic-enhanced.config my-custom.config

# 编辑添加需要的包
echo "CONFIG_PACKAGE_luci-app-wol=y" >> my-custom.config  # 网络唤醒
echo "CONFIG_PACKAGE_luci-app-watchcat=y" >> my-custom.config  # 网络监控

# OpenWRT K2P GitHub云编译项目

使用GitHub Actions自动编译OpenWRT固件，适用于斐讯K2P路由器。

## 功能特性

- GitHub Actions云编译，无需本地环境
- 支持K2P专用配置
- 自动缓存依赖，加速编译
- 固件大小自动检查（16MB限制）
- 支持手动触发和自动触发

## 快速开始

### 1. 本地设置
\`\`\`bash
# 克隆或创建项目
git clone <你的仓库地址>
cd openwrt-k2p-build

# 运行设置脚本
chmod +x scripts/setup.sh
./scripts/setup.sh
\`\`\`

### 2. 推送到GitHub
\`\`\`bash
# 添加所有文件
git add .

# 提交更改
git commit -m "初始提交"

# 推送到GitHub
git push origin main
\`\`\`

### 3. 开始编译
1. 访问你的GitHub仓库
2. 点击"Actions"标签页
3. 选择"Build OpenWRT for Phicomm K2P"
4. 点击"Run workflow"
5. 等待编译完成（约30-60分钟）

## 项目结构
\`\`\`
openwrt-k2p-build/
├── .github/
│   └── workflows/
│       └── build-openwrt.yml
├── configs/
│   ├── device-phicomm_k2p.yml
│   └── k2p-minimal.config
├── scripts/
│   ├── setup.sh
│   └── git-helper.sh
├── patches/
├── docs/
└── README.md
\`\`\`

## 配置文件说明

### k2p-minimal.config
最小化系统配置，包含：
- 基本路由功能
- 无线支持
- SSH访问
- 防火墙

### device-phicomm_k2p.yml
设备硬件信息：
- CPU：MT7621AT 880MHz
- 内存：128MB DDR3
- 闪存：16MB SPI NOR

## 自定义配置

1. 编辑 \`configs/k2p-minimal.config\` 文件
2. 添加或删除需要的软件包
3. 注意固件大小限制（16MB）

## 编译输出

编译完成后，在GitHub Actions页面可以下载：
- \`openwrt-ramips-mt7621-phicomm_k2p-squashfs-sysupgrade.bin\`
- 配置文件备份
- 编译日志

## 注意事项

1. **固件大小**：K2P只有16MB闪存，注意不要添加过多功能
2. **首次编译**：需要下载大量依赖，可能需要较长时间
3. **刷机风险**：刷机前请备份原厂固件
4. **默认IP**：刷机后路由器IP为192.168.1.1

## 常见问题

### Q: 编译失败怎么办？
A: 查看Actions日志，通常是因为：
   - 网络问题导致下载失败
   - 配置错误
   - 依赖包冲突

### Q: 如何添加更多功能？
A: 编辑 \`configs/k2p-minimal.config\` 文件，添加需要的软件包

### Q: 固件太大刷不进去？
A: 减少不必要的软件包，使用 \`# CONFIG_PACKAGE_xxx is not set\` 禁用不需要的包

## 支持与反馈

如有问题，请提交GitHub Issue。

## 许可证

MIT License

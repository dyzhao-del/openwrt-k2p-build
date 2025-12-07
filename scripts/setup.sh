#!/bin/bash
# OpenWRT编译环境设置脚本

set -e

echo "🔧 设置OpenWRT编译环境..."

# 检查Git是否安装
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装，请先安装Git"
    exit 1
fi

# 检查目录结构
echo "📁 检查目录结构..."
DIRS=(".github/workflows" "configs" "scripts" "patches" "docs")
for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "创建目录: $dir"
        mkdir -p "$dir"
    fi
done

# 检查必要文件
echo "📄 检查必要文件..."
REQUIRED_FILES=(
    ".github/workflows/build-openwrt.yml"
    "configs/device-phicomm_k2p.yml"
    "configs/k2p-minimal.config"
)
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ 文件不存在: $file"
        exit 1
    fi
done

echo "✅ 环境检查完成！"
echo ""
echo "下一步："
echo "1. 提交更改: git add . && git commit -m 'Initial setup'"
echo "2. 推送到GitHub: git push origin main"
echo "3. 访问GitHub仓库的Actions页面开始编译"

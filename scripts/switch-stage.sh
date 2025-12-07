#!/bin/bash
# OpenWRT编译阶段切换脚本

set -e

echo "🔄 OpenWRT K2P编译阶段切换工具"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 显示当前阶段
show_current_stage() {
    echo -e "${YELLOW}当前配置阶段:${NC}"
    
    if [ -f "configs/k2p-minimal.config" ]; then
        MINIMAL_SIZE=$(wc -l < configs/k2p-minimal.config)
        echo "  阶段1 (最小系统): $MINIMAL_SIZE 行配置"
    fi
    
    if [ -f "configs/k2p-stage2-extended.config" ]; then
        STAGE2_SIZE=$(wc -l < configs/k2p-stage2-extended.config)
        STAGE2_PACKAGES=$(grep "^CONFIG_PACKAGE.*=y$" configs/k2p-stage2-extended.config | wc -l)
        echo "  阶段2 (扩展功能): $STAGE2_SIZE 行配置, $STAGE2_PACKAGES 个包"
    fi
    
    if [ -f "configs/k2p-stage3-advanced.config" ]; then
        STAGE3_SIZE=$(wc -l < configs/k2p-stage3-advanced.config)
        echo "  阶段3 (高级功能): $STAGE3_SIZE 行配置"
    fi
}

# 显示帮助
show_help() {
    echo "使用方法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  status     显示当前阶段状态"
    echo "  compare    比较不同阶段的差异"
    echo "  prepare    准备提交并触发编译"
    echo "  help       显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 status"
    echo "  $0 compare"
    echo "  $0 prepare 2 \"添加Web管理界面\""
}

# 比较阶段差异
compare_stages() {
    echo -e "${YELLOW}比较阶段差异:${NC}"
    
    if [ ! -f "configs/k2p-minimal.config" ] || [ ! -f "configs/k2p-stage2-extended.config" ]; then
        echo -e "${RED}错误: 缺少配置文件${NC}"
        exit 1
    fi
    
    echo "阶段2相对于阶段1新增的包:"
    echo "=========================="
    
    # 提取阶段2特有的包
    grep "^CONFIG_PACKAGE" configs/k2p-stage2-extended.config | grep "=y$" | sort > /tmp/stage2_packages.txt
    grep "^CONFIG_PACKAGE" configs/k2p-minimal.config | grep "=y$" | sort > /tmp/stage1_packages.txt
    
    comm -13 /tmp/stage1_packages.txt /tmp/stage2_packages.txt | sed 's/CONFIG_PACKAGE_//;s/=y$//'
    
    echo ""
    echo -e "${GREEN}总计新增: $(comm -13 /tmp/stage1_packages.txt /tmp/stage2_packages.txt | wc -l) 个包${NC}"
    
    # 清理临时文件
    rm -f /tmp/stage1_packages.txt /tmp/stage2_packages.txt
}

# 准备提交
prepare_commit() {
    STAGE="$1"
    MESSAGE="$2"
    
    if [ -z "$STAGE" ]; then
        echo -e "${RED}错误: 需要指定阶段编号${NC}"
        echo "使用方法: $0 prepare [1|2|3] \"提交信息\""
        exit 1
    fi
    
    if [ -z "$MESSAGE" ]; then
        echo -e "${RED}错误: 需要提交信息${NC}"
        exit 1
    fi
    
    # 检查配置文件是否存在
    CONFIG_FILE="configs/k2p-stage${STAGE}-extended.config"
    if [ "$STAGE" = "1" ]; then
        CONFIG_FILE="configs/k2p-minimal.config"
    elif [ "$STAGE" = "3" ]; then
        CONFIG_FILE="configs/k2p-stage3-advanced.config"
    fi
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}错误: 配置文件不存在: $CONFIG_FILE${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}准备提交阶段 $STAGE 配置...${NC}"
    
    # 添加到Git
    git add "$CONFIG_FILE"
    git add configs/device-phicomm_k2p.yml
    git add .github/workflows/build-openwrt.yml
    
    # 提交
    git commit -m "Stage $STAGE: $MESSAGE"
    
    echo -e "${GREEN}✅ 提交完成！${NC}"
    echo ""
    echo "下一步操作:"
    echo "1. 推送到GitHub: git push origin main"
    echo "2. 访问GitHub Actions页面"
    echo "3. 手动触发编译，选择阶段 $STAGE"
}

# 主逻辑
case "$1" in
    "status")
        show_current_stage
        ;;
        
    "compare")
        compare_stages
        ;;
        
    "prepare")
        prepare_commit "$2" "$3"
        ;;
        
    "help"|"--help"|"-h")
        show_help
        ;;
        
    *)
        echo -e "${RED}未知命令: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

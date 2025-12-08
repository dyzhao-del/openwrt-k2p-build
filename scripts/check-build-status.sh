#!/bin/bash
# 检查构建状态（需要gh CLI）

echo "🔍 检查构建状态"

# 检查是否安装了gh CLI
if command -v gh &> /dev/null; then
  echo "GitHub CLI已安装"
  
  # 获取最近的工作流运行
  echo -e "\n最近的工作流运行:"
  gh run list --workflow="Build Official Style" --limit=3
  
  # 获取工作流ID
  RUN_ID=$(gh run list --workflow="Build Official Style" --limit=1 --json databaseId --jq '.[0].databaseId' 2>/dev/null)
  if [ -n "$RUN_ID" ]; then
    echo -e "\n最新运行ID: $RUN_ID"
    echo "查看详情: gh run view $RUN_ID"
    echo "查看日志: gh run watch $RUN_ID"
  fi
else
  echo "未安装GitHub CLI"
  echo "安装方法:"
  echo "  Ubuntu: sudo apt install gh"
  echo "  或访问: https://cli.github.com/"
  echo -e "\n手动检查:"
  echo "1. 访问: https://bgithub.xyz/dyzhao-del/openwrt-k2p-build/actions"
  echo "2. 查看 'Build Official Style' 工作流"
fi

echo -e "\n📋 构建配置文件:"
ls -la configs/k2p-*.config | head -5

#!/bin/bash
# Git操作助手脚本

case "$1" in
    "init")
        echo "初始化Git仓库..."
        git init
        git add .
        git commit -m "Initial commit: OpenWRT K2P build configuration"
        ;;
        
    "status")
        git status
        ;;
        
    "commit")
        if [ -z "$2" ]; then
            echo "使用方法: ./scripts/git-helper.sh commit \"提交信息\""
            exit 1
        fi
        git add .
        git commit -m "$2"
        ;;
        
    "push")
        git push origin main
        ;;
        
    "log")
        git log --oneline -10
        ;;
        
    *)
        echo "使用方法: ./scripts/git-helper.sh [command]"
        echo "可用命令:"
        echo "  init     初始化仓库"
        echo "  status   查看状态"
        echo "  commit   提交更改"
        echo "  push     推送到远程"
        echo "  log      查看日志"
        ;;
esac

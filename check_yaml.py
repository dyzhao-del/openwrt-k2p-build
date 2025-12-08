#!/usr/bin/env python3
import yaml
import sys

def check_yaml_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 检查YAML语法
        data = yaml.safe_load(content)
        print(f"✅ YAML语法检查通过: {filepath}")
        print(f"找到的工作流: {data.get('name', '未命名')}")
        
        # 检查行69附近的内容
        lines = content.split('\n')
        print(f"\n📄 第65-75行内容:")
        for i in range(64, min(75, len(lines))):
            print(f"{i+1:3}: {lines[i]}")
        
        return True
    except yaml.YAMLError as e:
        print(f"❌ YAML语法错误: {filepath}")
        print(f"错误详情: {e}")
        
        # 显示有问题的行
        if hasattr(e, 'problem_mark'):
            mark = e.problem_mark
            print(f"错误位置: 行 {mark.line+1}, 列 {mark.column+1}")
            
            # 显示有问题的行附近内容
            lines = content.split('\n')
            start = max(0, mark.line - 3)
            end = min(len(lines), mark.line + 3)
            
            print(f"\n错误行附近内容 ({start+1}-{end+1}):")
            for i in range(start, end):
                prefix = ">>>" if i == mark.line else "   "
                print(f"{prefix} {i+1:3}: {lines[i]}")
        
        return False
    except Exception as e:
        print(f"❌ 其他错误: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("使用方法: python3 check_yaml.py <yaml文件>")
        sys.exit(1)
    
    for filepath in sys.argv[1:]:
        check_yaml_file(filepath)

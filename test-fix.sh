#!/bin/bash
echo "测试修复后的脚本..."

# 创建README.md
cat > test-README.md << 'END'
# 测试标题

包含代码块：
\`\`\`bash
echo "测试命令"
\`\`\`

包含反引号：\`code\`
END

echo "文件内容："
cat test-README.md

echo -e "\n文件大小："
wc -l test-README.md

# 清理
rm test-README.md

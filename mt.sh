#!/usr/bin/env bash

# 目标 bashrc（当前用户）
BASHRC="$HOME/.bashrc"

# 备份原始 bashrc
if [ -f "$BASHRC" ]; then
    backup_name="$BASHRC.bak.$(date +%Y%m%d%H%M%S)"
    cp "$BASHRC" "$backup_name"
    echo "已备份原始 $BASHRC 为 $backup_name"
fi

# 追加自定义主题
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by setup_hacker_prompt.sh) ===

# 双行黑客风提示符：
# 第一行：时间 + 用户名/主机名
#   - 用户名：红色
#   - 主机名：蓝色
#   - 外框：绿色
# 第二行：路径：黄色（外框绿色）

PS1='\n\[\e[1;32m\]┌─[\A]──[\[\e[1;31m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h\[\e[1;32m\]]\n└─[\[\e[1;33m\]\w\[\e[1;32m\]]# \[\e[0m\]'

# ls 绿色黑客风配色
alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF

echo "已写入黑客风主题到 $BASHRC"
echo "在当前 shell 中执行：  source \"$BASHRC\"  即可生效。"

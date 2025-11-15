#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BACKUP_PREFIX="$BASHRC.bak."
TAG_BEGIN="# === Hacker style prompt & ls colors (added by irismt) ==="
TAG_END="# === End hacker style ==="

# 备份当前 .bashrc
backup_bashrc() {
    if [ ! -f "$BASHRC" ]; then
        echo "⚠ 未找到 $BASHRC，当前用户似乎还没有 .bashrc，稍后会新建一个。"
        return
    fi
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    local backup_file="${BACKUP_PREFIX}${ts}"
    cp "$BASHRC" "$backup_file"
    echo "✅ 已备份当前 $BASHRC 为：$backup_file"
}

# 删除旧的 hacker 配置块，避免重复追加
remove_old_block() {
    if [ -f "$BASHRC" ]; then
        # 删除标记之间的旧配置块
        sed -i "/$TAG_BEGIN/,/$TAG_END/d" "$BASHRC"
    fi
}

# 应用美化配置
apply_theme() {
    echo "== 应用 irismt 终端美化 =="

    backup_bashrc
    remove_old_block

    # 如果 .bashrc 不存在则创建
    if [ ! -f "$BASHRC" ]; then
        touch "$BASHRC"
    fi

    cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 双行黑客风提示符：
# 第一行：时间 + 用户名/主机名
#   - 用户名：红色
#   - 主机名：蓝色
#   - 外框：绿色
# 第二行：路径：黄色（外框绿色）

PS1='\n\[\e[1;32m\]┌─[\A]──[\[\e[1;31m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h\[\e[1;32m\]]\n└─[\[\e[1;33m\]\w\[\e[1;32m\]]# \[\e[0m\]'

# ls 绿色黑客风配色
alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF

    echo
    echo "🎉 美化已完成！"
    echo "👉 在当前 shell 中执行：  source \"$BASHRC\"  即可立刻生效。"
}

# 从备份列表中选择一个进行还原
restore_from_backup() {
    echo "== 还原 .bashrc 配置 =="

    # 找到所有备份文件
    mapfile -t backups < <(ls -1 "${BACKUP_PREFIX}"* 2>/dev/null)

    if [ ${#backups[@]} -eq 0 ]; then
        echo "❌ 没有找到任何备份文件（形如：${BACKUP_PREFIX}YYYYMMDDHHMMSS）"
        return
    fi

    echo "找到以下备份文件："
    local i
    for i in "${!backups[@]}"; do
        printf "  %d) %s\n" $((i+1)) "${backups[i]}"
    done
    echo "  0) 取消还原，返回主菜单"
    echo

    local choice
    while true; do
        read -rp "请输入要还原的序号（0 取消）： " choice
        # 简单校验是数字
        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            echo "❌ 请输入数字。"
            continue
        fi

        if [ "$choice" -eq 0 ]; then
            echo "已取消还原"
            return
        fi

        if [ "$choice" -ge 1 ] && [ "$choice" -le ${#backups[@]} ]; then
            local selected="${backups[$((choice-1))]}"
            break
        else
            echo "❌ 无效的序号，请重新输入。"
        fi
    done

    echo "你选择了备份文件：$selected"
    echo

    # 先备份当前 .bashrc（防止后悔）
    if [ -f "$BASHRC" ]; then
        local ts
        ts=$(date +%Y%m%d%H%M%S)
        local current_backup="$BASHRC.before_restore.$ts"
        cp "$BASHRC" "$current_backup"
        echo "已备份当前 $BASHRC 为：$current_backup"
    fi

    # 执行恢复
    cp "$selected" "$BASHRC"
    echo "✅ 已使用备份文件恢复：$selected"
    echo
    echo "👉 请执行：  source \"$BASHRC\"  让还原后的配置立刻生效。"
}

main_menu() {
    while true; do
        echo
        echo "================ irismt 脚本菜单 ================"
        echo "  1) 应用终端美化（Hacker 风格提示符 + ls 颜色）"
        echo "  2) 从备份列表中选择一个版本还原 .bashrc"
        echo "  0) 退出脚本"
        echo "================================================"
        read -rp "请输入选项（0/1/2）： " opt

        case "$opt" in
            1)
                apply_theme
                ;;
            2)
                restore_from_backup
                ;;
            0)
                echo "退出脚本，再见～"
                break
                ;;
            *)
                echo "❌ 无效选项，请输入 0、1 或 2。"
                ;;
        esac
    done
}

main_menu

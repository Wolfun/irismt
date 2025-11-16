#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BACKUP_PREFIX="$BASHRC.bak."
TAG_BEGIN="# === Hacker style prompt & ls colors (added by irismt) ==="
TAG_END="# === End hacker style ==="

# 判断脚本是否被 source
is_sourced() {
    [[ "$0" != "${BASH_SOURCE[0]}" ]]
}

# 备份当前 .bashrc
backup_bashrc() {
    if [ -f "$BASHRC" ]; then
        local ts backup_file
        ts=$(date +%Y%m%d%H%M%S)
        backup_file="${BACKUP_PREFIX}${ts}"
        cp "$BASHRC" "$backup_file"
        echo "✅ 已备份当前 .bashrc 为：$backup_file"
    fi
}

# 删除旧主题内容
remove_old_block() {
    sed -i "/$TAG_BEGIN/,/$TAG_END/d" "$BASHRC"
}

# =============================
# 6 个主题
# =============================

write_theme_block() {
    local theme="$1"

    [ -f "$BASHRC" ] || touch "$BASHRC"

    case "$theme" in

        # 主题 1 — Hacker Green Line
        1)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\n\
\[\e[1;32m\]┌─[\[\e[0;32m\]\A\[\e[1;32m\]]──[\[\e[1;31m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h\[\e[1;32m\]]\n\
└─[\[\e[1;33m\]\w\[\e[1;32m\]]# \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        # 主题 2 — Cyber Arrow
        2)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\] \[\e[1;37m\]→\[\e[0m\] \[\e[1;33m\]\w\[\e[0m\] # '

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        # 主题 3 — Matrix OneLine
        3)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\[\e[1;32m\]\u@\h:\w# \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        # 主题 4 — Info HUD
        4)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\[\e[1;36m\][\A]\[\e[0m\] \[\e[1;31m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\]# '

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        # 主题 5 — Azure Hacker Line（浅蓝框 + 浅绿时间）
        5)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\n\
\[\e[1;36m\]┌─[\[\e[1;32m\]\A\[\e[1;36m\]]──[\[\e[1;31m\]\u\[\e[1;36m\]@\[\e[1;34m\]\h\[\e[1;36m\]]\n\
└─[\[\e[1;33m\]\w\[\e[1;36m\]]# \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        # 主题 6 — Ocean Hacker Line（海蓝配色双行，> 结尾）
        6)
cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

PS1='\n\
\[\e[38;2;69;171;186m\]┌─[\[\e[38;2;130;205;208m\]\A\[\e[38;2;69;171;186m\]]──[\[\e[38;2;99;141;163m\]\u\[\e[38;2;69;171;186m\]@\[\e[38;2;9;121;113m\]\h\[\e[38;2;69;171;186m\]]\n\
└─[\[\e[38;2;245;230;99m\]\w\[\e[38;2;69;171;186m\]] > \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===
EOF
            ;;

        *)
            echo "❌ 无效主题：$theme"
            ;;
    esac
}

# =============================
# 应用主题（修正 0–6 选择）
# =============================
apply_theme() {
    echo "== 选择美化方案 =="

    echo "  1. Hacker Green Line（绿框双行）"
    echo "  2. Cyber Arrow（箭头风）"
    echo "  3. Matrix OneLine（全绿单行）"
    echo "  4. Info HUD（带时间信息）"
    echo "  5. Azure Hacker Line（浅蓝双行 + 浅绿时间）"
    echo "  6. Ocean Hacker Line（海蓝配色双行#替换>）"
    echo "  0. 返回主菜单"
    echo

    local t
    while true; do
        read -rp "请输入 0-6： " t
        case "$t" in
            0|1|2|3|4|5|6)
                break
                ;;
            *)
                echo "❌ 请输入 0~6"
                ;;
        esac
    done

    if [ "$t" = "0" ]; then
        echo "已取消美化，返回主菜单。"
        return
    fi

    backup_bashrc
    remove_old_block
    write_theme_block "$t"

    echo
    if is_sourced; then
        . "$BASHRC"
        echo "🎉 美化完成（当前终端已自动应用）"
    else
        echo "🎉 美化已写入 .bashrc"
        echo "👉 运行： source ~/.bashrc  生效"
    fi
}

# =============================
# 还原功能
# =============================
restore_from_backup() {
    echo "== 还原 .bashrc =="

    mapfile -t backups < <(ls -1 "${BACKUP_PREFIX}"* 2>/dev/null)

    if [ ${#backups[@]} -eq 0 ]; then
        echo "❌ 没找到任何备份"
        return
    fi

    echo "可恢复的备份："
    local i
    for i in "${!backups[@]}"; do
        printf "  %d. %s\n" $((i+1)) "${backups[i]}"
    done
    echo "  0. 取消"
    echo

    local choice
    while true; do
        read -rp "请选择恢复编号： " choice
        [[ "$choice" =~ ^[0-9]+$ ]] || { echo "请输入数字。"; continue; }
        break
    done

    [[ "$choice" -eq 0 ]] && return

    local selected="${backups[$((choice-1))]}"

    cp "$selected" "$BASHRC"
    echo "已恢复：$selected"

    if is_sourced; then
        . "$BASHRC"
        echo "当前终端已自动应用。"
    else
        echo "👉 请执行： source ~/.bashrc"
    fi
}

# =============================
# 功能 3：自定义 hostname
# =============================
change_hostname() {
    echo "== 修改 hostname =="

    local current_host newhost
    current_host=$(hostname)
    echo "当前 hostname：$current_host"
    echo

    read -rp "请输入新的 hostname： " newhost

    if [[ -z "$newhost" ]]; then
        echo "❌ hostname 不能为空"
        return
    fi

    if [[ $EUID -ne 0 ]]; then
        echo "❌ 错误：需要 root 才能更改 hostname"
        return
    fi

    hostnamectl set-hostname "$newhost"

    # 更新 /etc/hosts
    if [ -f /etc/hosts ]; then
        sed -i "s/$current_host/$newhost/g" /etc/hosts
    fi

    echo "✅ hostname 修改成功：$newhost"
    echo "👉 建议重新登录使提示符立即更新"
}

# =============================
# 菜单
# =============================
main_menu() {
    while true; do
        echo
        echo "============== irismt 菜单 =============="
        echo "  1. 选择并应用终端美化方案（6 主题）"
        echo "  2. 从备份列表中选择版本还原 .bashrc"
        echo "  3. 修改 hostname（主机名）"
        echo "  0. 退出"
        echo "========================================="
        read -rp "请输入选项： " opt

        case "$opt" in
            1) apply_theme ;;
            2) restore_from_backup ;;
            3) change_hostname ;;
            0)
                echo "退出脚本"
                break
                ;;
            *)
                echo "❌ 无效选项"
                ;;
        esac
    done
}

main_menu

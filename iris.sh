#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BACKUP_PREFIX="$BASHRC.bak."
TAG_BEGIN="# === Hacker style prompt & ls colors (added by irismt) ==="
TAG_END="# === End hacker style ==="

# 判断脚本是被 source 运行还是被 bash 运行
is_sourced() {
    [[ "$0" != "${BASH_SOURCE[0]}" ]]
}

# 备份当前 .bashrc
backup_bashrc() {
    if [ ! -f "$BASHRC" ]; then
        echo "⚠ 未找到 $BASHRC，当前用户似乎还没有 .bashrc，稍后会新建一个。"
        return
    fi
    local ts backup_file
    ts=$(date +%Y%m%d%H%M%S)
    backup_file="${BACKUP_PREFIX}${ts}"
    cp "$BASHRC" "$backup_file"
    echo "✅ 已备份当前 $BASHRC 为：$backup_file"
}

# 删除旧的 irismt 配置块
remove_old_block() {
    if [ -f "$BASHRC" ]; then
        sed -i "/$TAG_BEGIN/,/$TAG_END/d" "$BASHRC"
    fi
}

# 写入主题块（1~5）
write_theme_block() {
    local theme="$1"

    [ -f "$BASHRC" ] || touch "$BASHRC"

    case "$theme" in
        1)
            # 主题 1：双行 Hacker 风（绿框 + 时间绿 + 红用户名 + 蓝主机 + 黄路径）
            cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 主题 1：双行 Hacker 风
# 第一行：绿色框 + 墨绿时间 + 红用户名 + 蓝主机
# 第二行：绿色框 + 黄色路径

PS1='\n\
\[\e[1;32m\]┌─[\[\e[0;32m\]\A\[\e[1;32m\]]──[\[\e[1;31m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h\[\e[1;32m\]]\n\
└─[\[\e[1;33m\]\w\[\e[1;32m\]]# \[\e[0m\]'

# ls 绿色黑客风配色
alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF
            ;;
        2)
            # 主题 2：单行彩色箭头风（root@iris → /path #）
            cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 主题 2：单行彩色箭头风
#   root@iris → /path #
#   - 用户名：红色
#   - 主机名：蓝色
#   - 路径：黄色
#   - 箭头：白色

PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\] \[\e[1;37m\]→\[\e[0m\] \[\e[1;33m\]\w\[\e[0m\] # '

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF
            ;;
        3)
            # 主题 3：极简 Matrix 绿风（全绿）
            cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 主题 3：极简 Matrix 绿风
#   root@iris:/path#

PS1='\[\e[1;32m\]\u@\h:\w# \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF
            ;;
        4)
            # 主题 4：信息风（时间 + 用户 + 主机 + 路径）
            cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 主题 4：信息风
#   [12:34] root@iris:/path#

PS1='\[\e[1;36m\][\A]\[\e[0m\] \[\e[1;31m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\]# '

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF
            ;;
        5)
            # 主题 5：你定制的版本
            #   样式与主题 1 相同（双行 Hacker 风）
            #   区别：
            #     - 连接线（┌─ ── └─）：浅蓝色（1;36）
            #     - 时间：[HH:MM]：墨绿（0;32）
            #     - 用户名：红色
            #     - 主机名：蓝色
            #     - 路径：黄色
            cat << 'EOF' >> "$BASHRC"

# === Hacker style prompt & ls colors (added by irismt) ===

# 主题 5：双行 Hacker 风（浅蓝框 + 墨绿时间）
# 第一行：浅蓝框 + 墨绿时间 + 红用户名 + 蓝主机
# 第二行：浅蓝框 + 黄路径

PS1='\n\
\[\e[1;36m\]┌─[\[\e[0;32m\]\A\[\e[1;36m\]]──[\[\e[1;31m\]\u\[\e[1;36m\]@\[\e[1;34m\]\h\[\e[1;36m\]]\n\
└─[\[\e[1;33m\]\w\[\e[1;36m\]]# \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End hacker style ===

EOF
            ;;
        *)
            echo "❌ 未知主题编号：$theme"
            return 1
            ;;
    esac
}

# 应用主题：备份 + 清理旧块 + 写新主题 + 尝试刷新
apply_theme() {
    echo "== 选择美化方案 =="

    echo "  1) 主题 1：双行 Hacker 风（绿框 + 时间绿 + 红用户名 + 蓝主机 + 黄路径）"
    echo "  2) 主题 2：单行彩色箭头风（root@iris → /path #）"
    echo "  3) 主题 3：极简 Matrix 绿风（全绿）"
    echo "  4) 主题 4：信息风（[12:34] root@iris:/path#）"
    echo "  5) 主题 5：双行 Hacker 浅蓝框 + 墨绿时间（你定制的主题）"
    echo "  0) 取消，返回主菜单"
    echo

    local t
    while true; do
        read -rp "请输入主题编号（0/1/2/3/4/5）： " t
        [[ "$t" =~ ^[0-5]$ ]] || { echo "❌ 请输入 0~5 的数字。"; continue; }
        break
    done

    if [ "$t" -eq 0 ]; then
        echo "已取消美化。"
        return
    fi

    backup_bashrc
    remove_old_block
    write_theme_block "$t" || return

    echo
    if is_sourced; then
        # 如果脚本是被 source 运行的，可以直接刷新当前 shell
        # shellcheck disable=SC1090
        . "$BASHRC"
        echo "🎉 美化已完成，并已自动执行：source \"$BASHRC\""
        echo "当前终端提示符已经更新。"
    else
        echo "🎉 美化已完成。"
        echo "⚠ 你是通过 'bash irismt.sh' / 'bash <(curl ...)' 方式运行脚本，"
        echo "   脚本在子 shell 中执行，无法自动刷新你当前这个终端的环境。"
        echo "👉 请在当前终端手动执行："
        echo "   source \"$BASHRC\""
        echo "   或者重新登录 / 重开一个终端，即可看到新效果。"
    fi
}

# 从备份列表中选择一个进行还原
restore_from_backup() {
    echo "== 还原 .bashrc 配置 =="

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
        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            echo "❌ 请输入数字。"
            continue
        fi
        if [ "$choice" -eq 0 ]; then
            echo "已取消还原。"
            return
        fi
        if [ "$choice" -ge 1 ] && [ "$choice" -le ${#backups[@]} ]; then
            break
        else
            echo "❌ 无效的序号，请重新输入。"
        fi
    done

    local selected="${backups[$((choice-1))]}"
    echo "你选择了备份文件：$selected"
    echo

    if [ -f "$BASHRC" ]; then
        local ts current_backup
        ts=$(date +%Y%m%d%H%M%S)
        current_backup="$BASHRC.before_restore.$ts"
        cp "$BASHRC" "$current_backup"
        echo "已备份当前 $BASHRC 为：$current_backup"
    fi

    cp "$selected" "$BASHRC"
    echo "✅ 已使用备份文件恢复：$selected"
    echo
    if is_sourced; then
        # shellcheck disable=SC1090
        . "$BASHRC"
        echo "已自动执行：source \"$BASHRC\"，当前终端已使用恢复后的配置。"
    else
        echo "👉 请在当前终端执行：  source \"$BASHRC\"  让还原后的配置立刻生效。"
    fi
}

main_menu() {
    while true; do
        echo
        echo "================ irismt 脚本菜单 ================"
        echo "  1) 选择并应用终端美化方案（共 5 个主题）"
        echo "  2) 从备份列表中选择一个版本还原 .bashrc"
        echo "  0) 退出脚本"
        echo "================================================"
        read -rp "请输入选项（0/1/2）： " opt

        case "$opt" in
            1) apply_theme ;;
            2) restore_from_backup ;;
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

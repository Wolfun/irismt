#!/usr/bin/env bash

# =============================
# 基本配置
# =============================
BASHRC="$HOME/.bashrc"
BACKUP_PREFIX="$BASHRC.twoline.bak."
TAG_BEGIN="# === TwoLine prompt (added by twoline.sh) ==="
TAG_END="# === End twoline.sh ==="

CONFIG_DIR="$HOME/.twoline"
SCHEMES_FILE="$CONFIG_DIR/schemes.conf"

mkdir -p "$CONFIG_DIR"

# =============================
# 工具函数
# =============================

# 判断脚本是否被 source 执行
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

# 把默认的 TwoLine 区块写入 .bashrc（如果不存在）
ensure_twoline_block() {
    if grep -qF "$TAG_BEGIN" "$BASHRC" 2>/dev/null; then
        return
    fi

    echo "首次使用，正在为你注入 TwoLine 区块到 ~/.bashrc ..."
    backup_bashrc

    cat << 'EOF' >> "$BASHRC"

# === TwoLine prompt (added by twoline.sh) ===
# 默认冷色调配色（Ocean）

TWOLINE_LINE_COLOR="38;2;69;171;186"   # 连接线
TWOLINE_TIME_COLOR="38;2;130;205;208"  # 时间
TWOLINE_USER_COLOR="38;2;99;141;163"   # 用户
TWOLINE_HOST_COLOR="38;2;9;121;113"    # 主机
TWOLINE_PATH_COLOR="38;2;245;230;99"   # 路径
TWOLINE_SYMBOL=">"

PS1='\n\
\[\e[${TWOLINE_LINE_COLOR}m\]┌─[\[\e[${TWOLINE_TIME_COLOR}m\]\A\[\e[${TWOLINE_LINE_COLOR}m\]]──[\[\e[${TWOLINE_USER_COLOR}m\]\u\[\e[${TWOLINE_LINE_COLOR}m\]@\[\e[${TWOLINE_HOST_COLOR}m\]\h\[\e[${TWOLINE_LINE_COLOR}m\]]\n\
└─[\[\e[${TWOLINE_PATH_COLOR}m\]\w\[\e[${TWOLINE_LINE_COLOR}m\]] ${TWOLINE_SYMBOL} \[\e[0m\]'

alias ls='ls --color=auto'
export LS_COLORS='di=1;32:ln=1;36:so=1;32:pi=1;32:ex=1;32:bd=1;32:cd=1;32:su=1;32:sg=1;32:tw=32:ow=32'

# === End twoline.sh ===
EOF

    echo "✅ 已注入 TwoLine 区块。"
}

# 更新 .bashrc 中某个 TWOLINE_* 变量
set_var_in_bashrc() {
    local var="$1"
    local value="$2"
    if grep -q "^${var}=" "$BASHRC" 2>/dev/null; then
        sed -i "s|^${var}=.*|${var}=\"${value}\"|" "$BASHRC"
    else
        # 如果变量不存在，就追加到 TAG_BEGIN 后
        awk -v v="${var}" -v val="${value}" -v tag="$TAG_BEGIN" '
            BEGIN {inserted = 0}
            {
                print $0
                if (index($0, tag) && !inserted) {
                    printf("%s=\"%s\"\n", v, val)
                    inserted = 1
                }
            }' "$BASHRC" > "${BASHRC}.tmp" && mv "${BASHRC}.tmp" "$BASHRC"
    fi
}

# 把一个配色方案应用到 .bashrc
apply_scheme() {
    local line="$1" time="$2" user="$3" host="$4" path="$5" symbol="$6"

    ensure_twoline_block
    backup_bashrc

    set_var_in_bashrc "TWOLINE_LINE_COLOR" "$line"
    set_var_in_bashrc "TWOLINE_TIME_COLOR" "$time"
    set_var_in_bashrc "TWOLINE_USER_COLOR" "$user"
    set_var_in_bashrc "TWOLINE_HOST_COLOR" "$host"
    set_var_in_bashrc "TWOLINE_PATH_COLOR" "$path"
    set_var_in_bashrc "TWOLINE_SYMBOL" "$symbol"

    echo
    if is_sourced; then
        # shellcheck disable=SC1090
        . "$BASHRC"
        echo "🎉 已应用配色方案，并自动刷新当前终端。"
    else
        echo "🎉 已应用配色方案到 ~/.bashrc"
        echo "👉 请执行：  source ~/.bashrc  让效果立即生效。"
    fi
}

# 16 进制颜色 (#RRGGBB) 转为 38;2;R;G;B
hex_to_seq() {
    local hex="$1"
    hex="${hex#\#}"
    if [[ ${#hex} -ne 6 ]]; then
        return 1
    fi
    local r g b
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "38;2;${r};${g};${b}"
}

# 预览一套配色
preview_scheme() {
    local line="$1" time="$2" user="$3" host="$4" path="$5" symbol="$6"

    echo
    echo "配色预览："
    echo -e "  \e[${line}m连接线(Line)\e[0m    => ${line}"
    echo -e "  \e[${time}m时间(Time)\e[0m     => ${time}"
    echo -e "  \e[${user}m用户(User)\e[0m     => ${user}"
    echo -e "  \e[${host}m主机(Host)\e[0m     => ${host}"
    echo -e "  \e[${path}m路径(Path)\e[0m     => ${path}"
    echo "  结尾符号(Symbol)：${symbol}"
    echo
}

# =============================
# 1. 内置配色方案（冷色调三套）
# =============================

apply_builtin_menu() {
    echo "== 内置配色方案（冷色调） =="
    echo "  1. Ocean (海蓝系，默认)"
    echo "  2. NightSky (夜空紫蓝系)"
    echo "  3. Ice (冰蓝淡色系)"
    echo "  0. 返回主菜单"
    echo

    local c
    while true; do
        read -rp "请选择 0-3： " c
        case "$c" in
            0) return ;;
            1|2|3) break ;;
            *) echo "❌ 请输入 0~3" ;;
        esac
    done

    local line time user host path symbol
    symbol=">"

    case "$c" in
        1)
            # Ocean：海蓝系（你之前的 ocean 风格）
            line="38;2;69;171;186"    # #45ABBA
            time="38;2;130;205;208"   # #82CDD0
            user="38;2;99;141;163"    # #638DA3
            host="38;2;9;121;113"     # #097971
            path="38;2;245;230;99"    # #F5E663
            ;;
        2)
            # NightSky：夜空紫蓝系
            line="38;2;75;63;114"     # #4B3F72
            time="38;2;187;134;252"   # #BB86FC
            user="38;2;236;239;244"   # #ECEFF4
            host="38;2;94;129;172"    # #5E81AC
            path="38;2;136;192;208"   # #88C0D0
            ;;
        3)
            # Ice：冰蓝淡色系
            line="38;2;129;161;193"   # #81A1C1
            time="38;2;229;233;240"   # #E5E9F0
            user="38;2;94;129;172"    # #5E81AC
            host="38;2;143;188;187"   # #8FBCBB
            path="38;2;216;222;233"   # #D8DEE9
            ;;
    esac

    preview_scheme "$line" "$time" "$user" "$host" "$path" "$symbol"
    read -rp "是否应用该内置方案？(y/n)： " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        apply_scheme "$line" "$time" "$user" "$host" "$path" "$symbol"
    else
        echo "已取消应用。"
    fi
}

# =============================
# 2. 自定义配色
# =============================

# 交互式输入一个颜色（十六进制），带默认值
prompt_color_hex() {
    local label="$1"
    local default_hex="$2"
    local hex seq
    while true; do
        read -rp "请输入 ${label} 颜色（16进制，如 #45ABBA，回车使用默认 ${default_hex}）： " hex
        if [ -z "$hex" ]; then
            hex="$default_hex"
        fi
        seq=$(hex_to_seq "$hex") || {
            echo "❌ 格式不正确，请重新输入。"
            continue
        }
        echo "$seq"
        return 0
    done
}

# 保存自定义方案到文件
save_custom_scheme() {
    local name="$1" line="$2" time="$3" user="$4" host="$5" path="$6" symbol="$7"

    # 名称简单过滤（去掉竖线）
    name="${name//|/_}"

    echo "${name}|${line}|${time}|${user}|${host}|${path}|${symbol}" >> "$SCHEMES_FILE"
    echo "✅ 已保存自定义方案：$name"
}

# 列出现有自定义方案
list_custom_schemes() {
    if [ ! -s "$SCHEMES_FILE" ]; then
        return 1
    fi
    echo "已有自定义方案："
    local i=1
    while IFS='|' read -r name line time user host path symbol; do
        printf "  %d. %s\n" "$i" "$name"
        i=$((i+1))
    done < "$SCHEMES_FILE"
    return 0
}

# 选择并应用已有自定义方案
choose_custom_scheme() {
    if ! list_custom_schemes; then
        echo "⚠ 目前还没有自定义方案。"
        return
    fi

    echo "  0. 返回上一级"
    echo

    local count choice
    count=$(wc -l < "$SCHEMES_FILE")
    while true; do
        read -rp "请选择方案编号（0 返回）： " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le "$count" ]; then
            break
        fi
        echo "❌ 请输入 0-${count} 之间的数字。"
    done

    if [ "$choice" -eq 0 ]; then
        return
    fi

    local line
    line=$(sed -n "${choice}p" "$SCHEMES_FILE")
    IFS='|' read -r name line_c time_c user_c host_c path_c symbol_c <<< "$line"

    echo "你选择了方案：$name"
    preview_scheme "$line_c" "$time_c" "$user_c" "$host_c" "$path_c" "$symbol_c"
    read -rp "是否应用该方案？(y/n)： " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        apply_scheme "$line_c" "$time_c" "$user_c" "$host_c" "$path_c" "$symbol_c"
    else
        echo "已取消应用。"
    fi
}

# 创建新自定义方案
create_custom_scheme() {
    echo "== 创建新的自定义双行配色方案 =="
    echo "提示：直接回车会使用括号里的默认颜色。"
    echo

    # 默认沿用 Ocean 方案
    local line time user host path symbol
    line=$(prompt_color_hex "连接线(Line)" "#45ABBA")
    time=$(prompt_color_hex "时间(Time)" "#82CDD0")
    user=$(prompt_color_hex "用户(User)" "#638DA3")
    host=$(prompt_color_hex "主机(Host)" "#097971")
    path=$(prompt_color_hex "路径(Path)" "#F5E663")

    read -rp "请输入结尾符号（例如 # 或 >，默认 #）： " symbol
    [ -z "$symbol" ] && symbol="#"

    preview_scheme "$line" "$time" "$user" "$host" "$path" "$symbol"

    read -rp "是否应用这套自定义方案？(y/n)： " yn
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        apply_scheme "$line" "$time" "$user" "$host" "$path" "$symbol"
    else
        echo "已取消应用，但你可以选择保存以便以后使用。"
    fi

    read -rp "是否保存这套方案为“自定义主题”？(y/n)： " save
    if [[ "$save" =~ ^[Yy]$ ]]; then
        read -rp "请为这套方案起一个名字（推荐英文或拼音）： " name
        [ -z "$name" ] && name="custom_$(date +%H%M%S)"
        save_custom_scheme "$name" "$line" "$time" "$user" "$host" "$path" "$symbol"
    else
        echo "未保存该方案。"
    fi
}

# 自定义总菜单
custom_menu() {
    echo "== 自定义配色 =="
    if [ -s "$SCHEMES_FILE" ]; then
        echo "  1. 使用已有自定义方案"
        echo "  2. 创建新的自定义方案"
        echo "  0. 返回主菜单"
        echo

        local c
        while true; do
            read -rp "请选择 0-2： " c
            case "$c" in
                0) return ;;
                1) choose_custom_scheme; return ;;
                2) create_custom_scheme; return ;;
                *) echo "❌ 请输入 0/1/2" ;;
            esac
        done
    else
        echo "当前还没有自定义方案，直接进入创建流程。"
        echo
        create_custom_scheme
    fi
}

# =============================
# 3. 备份还原
# =============================
backup_restore_menu() {
    echo "== 备份 / 还原 .bashrc =="

    mapfile -t backups < <(ls -1 "${BACKUP_PREFIX}"* 2>/dev/null)

    if [ ${#backups[@]} -eq 0 ]; then
        echo "⚠ 还没有任何 twoline.sh 创建的备份。"
        echo "提示：每次应用新方案时都会自动备份一次。"
        return
    fi

    echo "可用备份："
    local i
    for i in "${!backups[@]}"; do
        printf "  %d. %s\n" $((i+1)) "${backups[i]}"
    done
    echo "  0. 取消"
    echo

    local choice
    while true; do
        read -rp "请选择要恢复的编号（0 取消）： " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le ${#backups[@]} ]; then
            break
        fi
        echo "❌ 输入无效，请重新输入。"
    done

    [ "$choice" -eq 0 ] && return

    local selected="${backups[$((choice-1))]}"
    cp "$selected" "$BASHRC"
    echo "✅ 已恢复：$selected"

    if is_sourced; then
        # shellcheck disable=SC1090
        . "$BASHRC"
        echo "当前终端已自动应用恢复后的配置。"
    else
        echo "👉 请执行： source ~/.bashrc  让恢复后的配置生效。"
    fi
}

# =============================
# 主菜单
# =============================
main_menu() {
    while true; do
        echo
        echo "============== TwoLine 双行主题管理 =============="
        echo "  1. 使用内置三种冷色调配色方案"
        echo "  2. 自定义配色（可保存命名，下次复用）"
        echo "  3. 备份 / 还原 .bashrc"
        echo "  0. 退出脚本"
        echo "=================================================="
        read -rp "请输入选项： " opt

        case "$opt" in
            1) apply_builtin_menu ;;
            2) custom_menu ;;
            3) backup_restore_menu ;;
            0)
                echo "已退出 twoline.sh"
                break
                ;;
            *)
                echo "❌ 无效选项，请输入 0/1/2/3。"
                ;;
        esac
    done
}

main_menu

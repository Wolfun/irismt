美化命令提示行
# irisMT – Hacker Style Shell Theme

这是一个为 Linux 终端打造的 **双行黑客风主题（Hacker Style Prompt）**，使用更清晰的颜色搭配：

- 用户名：**红色**
- 主机名：**蓝色**
- 路径：**黄色**
- 外框线条：**黑客绿**

同时增强了 ls 文件颜色显示（绿色主题），更符合黑客风格。

本脚本适用于：

- Ubuntu / Debian
- CentOS / Rocky / AlmaLinux
- Kali / Parrot
- 以及任何 Bash Shell 的 Linux VPS

---

## 🚀 一键安装（推荐）

只要一条命令即可安装：

```bash
bash <(curl -s https://raw.githubusercontent.com/wolfun/irismt/main/mt.sh)
source ~/.bashrc

下载到本地后执行（备用方式）
curl -o setup_hacker_prompt.sh https://raw.githubusercontent.com/wolfun/irismt/main/mt.sh
chmod +x mt.sh
./mt.sh
source ~/.bashrc
终端效果展示

安装完成后你的终端会变成这样：
┌─[12:34]──[root@iris]
└─[/root]#

脚本功能说明
✔ 双行 Hacker 风 PS1 提示符

显示时间

显示用户名（红）

显示主机名（蓝）

显示当前路径（黄）

黑客绿边框结构

✔ ls 颜色优化

增强文件 & 目录颜色，使 ls 更易读：

目录：亮绿色

执行文件：绿色

链接：青色

✔ 自动备份 .bashrc

脚本运行前会自动备份当前 .bashrc，绝对安全。

项目结构
irismt/
 ├── mt.sh         # 主安装脚本
 └── README.md     # 项目说明

卸载方法（恢复原来的 .bashrc）
如果你想恢复旧的 bash 配置：
cp ~/.bashrc.bak.* ~/.bashrc
source ~/.bashrc

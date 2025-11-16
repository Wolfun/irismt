# irismt – Interactive Rich Shell Theme Manager  
终端美化脚本 · 多主题选择 · 自动备份还原  
作者：wolfun

---

## 🔥 irismt 是什么？

irismt（Iris Multi Theme）是一个 **终端提示符美化工具**，具有：

- ✔ 交互式菜单  
- ✔ 5 种专业主题可选  
- ✔ 自动备份 .bashrc  
- ✔ 可选择任意历史版本恢复  
- ✔ 不会覆盖其它配置  
- ✔ 支持所有 Linux 发行版（Bash Shell）

一个脚本，搞定美化 + 备份 + 还原。

---

## 🚀 一键运行（推荐）

```bash
bash <(curl -s https://raw.githubusercontent.com/Wolfun/irismt/master/iris.sh)
```

或者下载运行：
```bash
curl -o irismt.sh https://raw.githubusercontent.com/Wolfun/irismt/master/iris.sh
chmod +x iris.sh
bash iris.sh
```
或者这种形式
```bash
bash <(curl -sL https://raw.githubusercontent.com/Wolfun/irismt/master/irismt.sh)
```
含义：
curl：去网上把脚本内容拉下来
-s：silent，安静模式，不输出下载进度条
-L：follow redirect，如果 URL 有 301/302 重定向，会自动跟过去
bash <( … )：进程替换，把 curl 输出当成一个“临时文件”喂给 bash 执行
等价于：“从这个网址下载脚本 → 不保存到磁盘 → 直接交给 bash 运行”。

⚠ 如果想让美化立即生效，用：
```bash
source iris.sh
```
这样脚本会自动刷新当前终端。


| 主题编号  | 名称                             | 描述                       |
| ----- | ------------------------------ | ------------------------ |
| **1** | **Hacker Green Line**（黑客绿色双行风） | 双行结构、绿框、红用户名、蓝主机、黄路径     |
| **2** | **Cyber Arrow**（赛博箭头风）         | root@host → path 的酷炫箭头主题 |
| **3** | **Matrix OneLine**（矩阵单行绿风）     | 极简黑客绿，单行输出               |
| **4** | **Info HUD Prompt**（信息抬头显示风）   | [时间] root@host:path#     |
| **5** | **Azure Hacker Line**（天蓝黑客双行风） | 浅蓝框，墨绿时间，红用户名，蓝主机，黄路径    |

🔁 还原功能
每次美化前，脚本都会自动生成备份：
~/.bashrc.bak.YYYYMMDDHHMMSS

你可以在菜单中选择“还原”，然后：
列出所有备份
选择你要恢复的版本
立即恢复并自动应用（如果脚本用 source 执行）

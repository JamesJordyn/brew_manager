# Homebrew 交互式管理工具 README

## 中文说明

### 概述
这是一款基于 Homebrew 的交互式管理脚本，专为简化 macOS/Linux 系统中的软件包管理而设计。通过清晰的菜单导航，用户无需记忆复杂命令即可完成软件包的更新、安装、卸载等操作。

### 核心功能
- 交互式菜单操作，无需命令行知识
- 一键更新 Homebrew 源数据
- 批量升级所有已安装软件包
- 搜索软件包并区分类型（普通包/Cask 包）
- 自动识别软件包类型并完成安装
- 支持连续卸载多个软件包
- 分类展示已安装的软件包（普通包/Cask 包/服务）
- 清理缓存释放磁盘空间
- 检查 Homebrew 运行环境状态

### 使用步骤
1. 在终端中输入一下命令运行脚本：
   ```bash
   chmod +x brew_manager.sh
   cd /tmp; wget --no-check-certificate -O run.sh https://raw.githubusercontent.com/JamesJordyn/brew_manager/refs/heads/main/run.sh; chmod +x ./run.sh; ./run.sh
   ```
2. 根据菜单提示输入数字选择所需功能

### 注意事项
- 使用前请确保已安装 Homebrew（[官方安装教程](https://brew.sh/)）
- 部分系统操作可能需要管理员权限
- 脚本开源遵循 MIT 许可证，修改时请保留原作者信息


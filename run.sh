#!/bin/bash

# Homebrew 交互式管理脚本（版权增强版）
# 功能：通过菜单选择执行 Homebrew 各种操作
# 作者：JamesJordyn
# 说明：本脚本基于 MIT 许可证开源，可自由修改，但请保留原作者信息

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
NC=$(tput sgr0)

show_copyright() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  Homebrew 交互式管理工具 v1.0        ${NC}"
    echo -e "${GREEN}  作者: JamesJordyn                     ${NC}"
    echo -e "${GREEN}  本脚本基于 MIT 许可证开源               ${NC}"
    echo -e "${GREEN}  您可以自由修改，但请保留原作者信息     ${NC}"
    echo -e "${GREEN}======================================${NC}"
    sleep 1
}

show_title() {
    clear
    show_copyright()
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}         Homebrew 交互式管理工具        ${NC}"
    echo -e "${GREEN}======================================${NC}"
}

show_menu() {
    echo -e "${BLUE}[1]${NC} 更新 Homebrew"
    echo -e "${BLUE}[2]${NC} 升级所有软件包"
    echo -e "${BLUE}[3]${NC} 搜索软件包"
    echo -e "${BLUE}[4]${NC} 安装软件包"
    echo -e "${BLUE}[5]${NC} 卸载软件包"
    echo -e "${BLUE}[6]${NC} 列出所有已安装软件包"
    echo -e "${BLUE}[7]${NC} 清理 Homebrew 缓存"
    echo -e "${BLUE}[8]${NC} 显示 Homebrew 状态"
    echo -e "${RED}[0]${NC} 退出"
    echo -e "${GREEN}--------------------------------------${NC}"
}

update_brew() {
    echo -e "${YELLOW}正在更新 Homebrew...${NC}"
    brew update
    echo -e "${GREEN}Homebrew 更新完成${NC}"
    pause
}

upgrade_packages() {
    echo -e "${YELLOW}正在升级所有 Homebrew 软件包...${NC}"
    brew upgrade
    echo -e "${GREEN}软件包升级完成${NC}"
    pause
}

search_packages() {
    read -p "请输入要搜索的软件包名称: " search_term
    echo -e "${YELLOW}正在搜索软件包 '$search_term'...${NC}"
    
    normal_results=$(brew search "$search_term")
    cask_results=$(brew search --casks "$search_term")
    all_results=$(echo -e "$normal_results\n$cask_results" | sort -u)
    
    if [[ -z "$all_results" ]]; then
        echo -e "${RED}未找到相关软件包${NC}"
        pause
        return
    fi
    
    echo -e "${GREEN}搜索结果:${NC}"
    while IFS= read -r package; do
        if echo "$normal_results" | grep -q "^$package$" && echo "$cask_results" | grep -q "^$package$"; then
            echo -e "${CYAN}[普通+Cask]${NC} $package"
        elif echo "$cask_results" | grep -q "^$package$"; then
            echo -e "${BLUE}[Cask]${NC} $package"
        else
            echo -e "${GREEN}[普通]${NC} $package"
        fi
    done <<< "$all_results"
    
    read -p "请输入要安装的软件包名称 [不需要备注Cask，脚本自动判断](或按 Enter 返回): " install_choice
    
    if [[ -n "$install_choice" ]]; then
        if echo "$all_results" | grep -q "^$install_choice$"; then
            install_package "$install_choice"
        else
            echo -e "${RED}错误：选择的软件包不在搜索结果中${NC}"
            pause
        fi
    fi
}

install_package() {
    package_name="$1"
    
    if ! brew search "$package_name" | grep -q "$package_name"; then
        echo -e "${RED}错误：未找到软件包 '$package_name'${NC}"
        pause
        return
    fi
    
    if brew search --casks "$package_name" | grep -q "$package_name"; then
        echo -e "${YELLOW}安装 Cask 软件包 '$package_name'...${NC}"
        brew install --cask "$package_name"
    else
        echo -e "${YELLOW}安装普通软件包 '$package_name'...${NC}"
        brew install "$package_name"
    fi
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}软件包 '$package_name' 安装成功${NC}"
    else
        echo -e "${RED}软件包 '$package_name' 安装失败${NC}"
    fi
    pause
}

uninstall_package() {
    while true; do
        read -p "请输入要卸载的软件包名称 (或输入 'q' 返回): " package_name
        
        if [[ "$package_name" == "q" || "$package_name" == "Q" ]]; then
            break
        fi
        
        if ! brew list | grep -q "$package_name" && ! brew list --cask | grep -q "$package_name"; then
            echo -e "${RED}错误：软件包 '$package_name' 未安装${NC}"
            continue
        fi
        
        read -p "确定要卸载软件包 '$package_name' 吗？(y/n): " confirm
        if [[ "$confirm" != [yY] ]]; then
            echo -e "${YELLOW}已取消卸载操作${NC}"
            continue
        fi
        
        if brew list --cask | grep -q "$package_name"; then
            echo -e "${YELLOW}卸载 Cask 软件包 '$package_name'...${NC}"
            brew uninstall --cask "$package_name"
        else
            echo -e "${YELLOW}卸载普通软件包 '$package_name'...${NC}"
            brew uninstall "$package_name"
        fi
        
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}软件包 '$package_name' 卸载成功${NC}"
        else
            echo -e "${RED}软件包 '$package_name' 卸载失败${NC}"
        fi
        
        read -p "是否继续卸载其他软件包？(y/n): " continue_uninstall
        if [[ "$continue_uninstall" != [yY] ]]; then
            break
        fi
    done
}

list_packages() {
    echo -e "${BLUE}===== 已安装的普通软件包 ====${NC}"
    brew list
    
    echo -e "\n${BLUE}===== 已安装的 Cask 软件包 ====${NC}"
    brew list --cask
    
    echo -e "\n${BLUE}===== 已安装的服务 ====${NC}"
    brew services list
    
    show_post_list_options
}

show_post_list_options() {
    echo -e "\n${GREEN}--------------------------------------${NC}"
    echo -e "${BLUE}[1]${NC} 按 Enter 键返回菜单"
    echo -e "${BLUE}[2]${NC} 卸载软件包"
    echo -e "${GREEN}--------------------------------------${NC}"
    
    read -p "请选择操作 [1-2]: " choice
    
    case $choice in
        1) ;;
        2) uninstall_package ;;
        *) 
            echo -e "${RED}无效选择，返回菜单${NC}"
            sleep 1
            ;;
    esac
}

cleanup_brew() {
    echo -e "${YELLOW}正在清理 Homebrew 缓存...${NC}"
    brew cleanup -s
    echo -e "${GREEN}缓存清理完成${NC}"
    pause
}

show_status() {
    echo -e "${YELLOW}正在检查 Homebrew 状态...${NC}"
    brew doctor
    echo -e "\n${BLUE}Homebrew 版本:${NC}"
    brew --version
    pause
}

pause() {
    read -p "按 Enter 键继续..."
}

while true; do
    show_title
    show_menu
    
    read -p "请选择操作 [0-8]: " choice
    
    case $choice in
        1) update_brew ;;
        2) upgrade_packages ;;
        3) search_packages ;;
        4) 
            read -p "请输入要安装的软件包名称: " pkg
            install_package "$pkg"
            ;;
        5) uninstall_package ;;
        6) list_packages ;;
        7) cleanup_brew ;;
        8) show_status ;;
        0) 
            echo -e "${GREEN}感谢使用 Homebrew 管理工具，再见！${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}无效选择，请输入 0-8 之间的数字${NC}"
            pause
            ;;
    esac
done

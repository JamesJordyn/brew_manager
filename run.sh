#!/bin/bash

# Homebrew 交互式管理工具（双语版）
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

select_language() {
    echo -e "${GREEN}请选择语言 / Select Language:${NC}"
    echo -e "${BLUE}[1]${NC} 中文"
    echo -e "${BLUE}[2]${NC} English"
    
    while true; do
        read -p "请选择 [1-2]: " lang_choice
        case $lang_choice in
            1) LANG="zh"; break ;;
            2) LANG="en"; break ;;
            *) echo -e "${RED}无效选择，请输入 1 或 2${NC}" ;;
        esac
    done
}

load_language() {
    if [[ "$LANG" == "zh" ]]; then
        TITLE="Homebrew 交互式管理工具"
        COPYRIGHT="作者: JamesJordyn\n  本脚本基于 MIT 许可证开源\n  您可以自由修改，但请保留原作者信息"
        MENU_UPDATE="更新 Homebrew"
        MENU_UPGRADE="升级所有软件包"
        MENU_SEARCH="搜索软件包"
        MENU_INSTALL="安装软件包"
        MENU_UNINSTALL="卸载软件包"
        MENU_LIST="列出所有已安装软件包"
        MENU_CLEANUP="清理 Homebrew 缓存"
        MENU_STATUS="显示 Homebrew 状态"
        MENU_EXIT="退出"
        PROMPT_CHOICE="请选择操作 [0-8]: "
        SEARCH_PROMPT="请输入要搜索的软件包名称: "
        SEARCHING="正在搜索软件包 '%s'..."
        NO_RESULTS="未找到相关软件包"
        RESULTS_HEADER="搜索结果:"
        TYPE_NORMAL="普通"
        TYPE_CASK="Cask"
        TYPE_BOTH="普通+Cask"
        INSTALL_PROMPT="请输入要安装的软件包名称 [不需要备注Cask，脚本自动判断](或按 Enter 返回): "
        NOT_FOUND="错误：未找到软件包 '%s'"
        INSTALLING="安装 %s 软件包 '%s'..."
        SUCCESS="软件包 '%s' 安装成功"
        FAILURE="软件包 '%s' 安装失败"
        UNINSTALL_PROMPT="请输入要卸载的软件包名称 (或输入 'q' 返回): "
        NOT_INSTALLED="错误：软件包 '%s' 未安装"
        CONFIRM_UNINSTALL="确定要卸载软件包 '%s' 吗？(y/n): "
        UNINSTALLING="卸载 %s 软件包 '%s'..."
        UNINSTALL_SUCCESS="软件包 '%s' 卸载成功"
        UNINSTALL_FAILURE="软件包 '%s' 卸载失败"
        CONTINUE_UNINSTALL="是否继续卸载其他软件包？(y/n): "
        LIST_NORMAL="已安装的普通软件包"
        LIST_CASK="已安装的 Cask 软件包"
        LIST_SERVICES="已安装的服务"
        POST_LIST_OPTION_1="按 Enter 键返回菜单"
        POST_LIST_OPTION_2="卸载软件包"
        PROMPT_AFTER_LIST="请选择操作 [1-2]: "
        CLEANING="正在清理 Homebrew 缓存..."
        CLEAN_SUCCESS="缓存清理完成"
        CHECKING_STATUS="正在检查 Homebrew 状态..."
        BREW_VERSION="Homebrew 版本:"
        INVALID_CHOICE="无效选择，请输入 0-8 之间的数字"
        PRESS_ENTER="按 Enter 键继续..."
        THANKS="感谢使用 Homebrew 管理工具，再见！"
        UPGRADING="正在升级所有 Homebrew 软件包..."
        UPGRADE_SUCCESS="软件包升级完成"
        UPDATING="正在更新 Homebrew..."
        UPDATE_SUCCESS="Homebrew 更新完成"
        PROMPT_INSTALL="请输入要安装的软件包名称: "
    else
        TITLE="Homebrew Interactive Management Tool"
        COPYRIGHT="Author: JamesJordyn\n  This script is open source under the MIT license\n  You are free to modify it, but please retain the original author information"
        MENU_UPDATE="Update Homebrew"
        MENU_UPGRADE="Upgrade all packages"
        MENU_SEARCH="Search packages"
        MENU_INSTALL="Install package"
        MENU_UNINSTALL="Uninstall package"
        MENU_LIST="List all installed packages"
        MENU_CLEANUP="Clean up Homebrew cache"
        MENU_STATUS="Show Homebrew status"
        MENU_EXIT="Exit"
        PROMPT_CHOICE="Please select an operation [0-8]: "
        SEARCH_PROMPT="Enter the package name to search: "
        SEARCHING="Searching for package '%s'..."
        NO_RESULTS="No matching packages found"
        RESULTS_HEADER="Search results:"
        TYPE_NORMAL="Normal"
        TYPE_CASK="Cask"
        TYPE_BOTH="Normal+Cask"
        INSTALL_PROMPT="Enter the package name to install [no need to specify Cask, the script will auto-detect] (or press Enter to return): "
        NOT_FOUND="Error: Package '%s' not found"
        INSTALLING="Installing %s package '%s'..."
        SUCCESS="Package '%s' installed successfully"
        FAILURE="Failed to install package '%s'"
        UNINSTALL_PROMPT="Enter the package name to uninstall (or 'q' to return): "
        NOT_INSTALLED="Error: Package '%s' is not installed"
        CONFIRM_UNINSTALL="Are you sure you want to uninstall package '%s'? (y/n): "
        UNINSTALLING="Uninstalling %s package '%s'..."
        UNINSTALL_SUCCESS="Package '%s' uninstalled successfully"
        UNINSTALL_FAILURE="Failed to uninstall package '%s'"
        CONTINUE_UNINSTALL="Continue uninstalling other packages? (y/n): "
        LIST_NORMAL="Installed normal packages"
        LIST_CASK="Installed Cask packages"
        LIST_SERVICES="Installed services"
        POST_LIST_OPTION_1="Press Enter to return to menu"
        POST_LIST_OPTION_2="Uninstall package"
        PROMPT_AFTER_LIST="Select an option [1-2]: "
        CLEANING="Cleaning up Homebrew cache..."
        CLEAN_SUCCESS="Cache cleanup completed"
        CHECKING_STATUS="Checking Homebrew status..."
        BREW_VERSION="Homebrew version:"
        INVALID_CHOICE="Invalid selection, please enter a number between 0-8"
        PRESS_ENTER="Press Enter to continue..."
        THANKS="Thank you for using the Homebrew management tool, goodbye!"
        UPGRADING="Upgrading all Homebrew packages..."
        UPGRADE_SUCCESS="Package upgrade completed"
        UPDATING="Updating Homebrew..."
        UPDATE_SUCCESS="Homebrew update completed"
        PROMPT_INSTALL="Enter the package name to install: "
    fi
}

show_copyright() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  $TITLE        ${NC}"
    echo -e "${GREEN}  $COPYRIGHT     ${NC}"
    echo -e "${GREEN}======================================${NC}"
    sleep 1
}

show_title() {
    clear
    show_copyright
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}         $TITLE        ${NC}"
    echo -e "${GREEN}======================================${NC}"
}

show_menu() {
    echo -e "${BLUE}[1]${NC} $MENU_UPDATE"
    echo -e "${BLUE}[2]${NC} $MENU_UPGRADE"
    echo -e "${BLUE}[3]${NC} $MENU_SEARCH"
    echo -e "${BLUE}[4]${NC} $MENU_INSTALL"
    echo -e "${BLUE}[5]${NC} $MENU_UNINSTALL"
    echo -e "${BLUE}[6]${NC} $MENU_LIST"
    echo -e "${BLUE}[7]${NC} $MENU_CLEANUP"
    echo -e "${BLUE}[8]${NC} $MENU_STATUS"
    echo -e "${RED}[0]${NC} $MENU_EXIT"
    echo -e "${GREEN}--------------------------------------${NC}"
}

update_brew() {
    echo -e "${YELLOW}$UPDATING${NC}"
    brew update
    echo -e "${GREEN}$UPDATE_SUCCESS${NC}"
    pause
}

upgrade_packages() {
    echo -e "${YELLOW}$UPGRADING${NC}"
    brew upgrade
    echo -e "${GREEN}$UPGRADE_SUCCESS${NC}"
    pause
}

search_packages() {
    read -p "$SEARCH_PROMPT" search_term
    printf "${YELLOW}$SEARCHING${NC}\n" "$search_term"
    
    normal_results=$(brew search "$search_term")
    cask_results=$(brew search --casks "$search_term")
    all_results=$(echo -e "$normal_results\n$cask_results" | sort -u)
    
    if [[ -z "$all_results" ]]; then
        echo -e "${RED}$NO_RESULTS${NC}"
        pause
        return
    fi
    
    echo -e "${GREEN}$RESULTS_HEADER${NC}"
    while IFS= read -r package; do
        if echo "$normal_results" | grep -q "^$package$" && echo "$cask_results" | grep -q "^$package$"; then
            echo -e "${CYAN}[$TYPE_BOTH]${NC} $package"
        elif echo "$cask_results" | grep -q "^$package$"; then
            echo -e "${BLUE}[$TYPE_CASK]${NC} $package"
        else
            echo -e "${GREEN}[$TYPE_NORMAL]${NC} $package"
        fi
    done <<< "$all_results"
    
    read -p "$INSTALL_PROMPT" install_choice
    
    if [[ -n "$install_choice" ]]; then
        if echo "$all_results" | grep -q "^$install_choice$"; then
            install_package "$install_choice"
        else
            printf "${RED}$NOT_FOUND${NC}\n" "$install_choice"
            pause
        fi
    fi
}

install_package() {
    package_name="$1"
    
    if ! brew search "$package_name" | grep -q "$package_name"; then
        printf "${RED}$NOT_FOUND${NC}\n" "$package_name"
        pause
        return
    fi
    
    if brew search --casks "$package_name" | grep -q "$package_name"; then
        printf "${YELLOW}$INSTALLING${NC}\n" "$TYPE_CASK" "$package_name"
        brew install --cask "$package_name"
    else
        printf "${YELLOW}$INSTALLING${NC}\n" "$TYPE_NORMAL" "$package_name"
        brew install "$package_name"
    fi
    
    if [[ $? -eq 0 ]]; then
        printf "${GREEN}$SUCCESS${NC}\n" "$package_name"
    else
        printf "${RED}$FAILURE${NC}\n" "$package_name"
    fi
    pause
}

uninstall_package() {
    while true; do
        read -p "$UNINSTALL_PROMPT" package_name
        
        if [[ "$package_name" == "q" || "$package_name" == "Q" ]]; then
            break
        fi
        
        if ! brew list | grep -q "$package_name" && ! brew list --cask | grep -q "$package_name"; then
            printf "${RED}$NOT_INSTALLED${NC}\n" "$package_name"
            continue
        fi
        
        read -p "$(printf "$CONFIRM_UNINSTALL" "$package_name")" confirm
        if [[ "$confirm" != [yY] ]]; then
            echo -e "${YELLOW}已取消卸载操作${NC}"
            continue
        fi
        
        if brew list --cask | grep -q "$package_name"; then
            printf "${YELLOW}$UNINSTALLING${NC}\n" "$TYPE_CASK" "$package_name"
            brew uninstall --cask "$package_name"
        else
            printf "${YELLOW}$UNINSTALLING${NC}\n" "$TYPE_NORMAL" "$package_name"
            brew uninstall "$package_name"
        fi
        
        if [[ $? -eq 0 ]]; then
            printf "${GREEN}$UNINSTALL_SUCCESS${NC}\n" "$package_name"
        else
            printf "${RED}$UNINSTALL_FAILURE${NC}\n" "$package_name"
        fi
        
        read -p "$CONTINUE_UNINSTALL" continue_uninstall
        if [[ "$continue_uninstall" != [yY] ]]; then
            break
        fi
    done
}

list_packages() {
    echo -e "${BLUE}===== $LIST_NORMAL ====${NC}"
    brew list
    
    echo -e "\n${BLUE}===== $LIST_CASK ====${NC}"
    brew list --cask
    
    echo -e "\n${BLUE}===== $LIST_SERVICES ====${NC}"
    brew services list
    
    show_post_list_options
}

show_post_list_options() {
    echo -e "\n${GREEN}--------------------------------------${NC}"
    echo -e "${BLUE}[1]${NC} $POST_LIST_OPTION_1"
    echo -e "${BLUE}[2]${NC} $POST_LIST_OPTION_2"
    echo -e "${GREEN}--------------------------------------${NC}"
    
    read -p "$PROMPT_AFTER_LIST" choice
    
    case $choice in
        1) ;;
        2) uninstall_package ;;
        *) 
            echo -e "${RED}$INVALID_CHOICE${NC}"
            sleep 1
            ;;
    esac
}

cleanup_brew() {
    echo -e "${YELLOW}$CLEANING${NC}"
    brew cleanup -s
    echo -e "${GREEN}$CLEAN_SUCCESS${NC}"
    pause
}

show_status() {
    echo -e "${YELLOW}$CHECKING_STATUS${NC}"
    brew doctor
    echo -e "\n${BLUE}$BREW_VERSION:${NC}"
    brew --version
    pause
}

pause() {
    read -p "$PRESS_ENTER"
}

select_language
load_language

while true; do
    show_title
    show_menu
    
    read -p "$PROMPT_CHOICE" choice
    
    case $choice in
        1) update_brew ;;
        2) upgrade_packages ;;
        3) search_packages ;;
        4) 
            read -p "$PROMPT_INSTALL" pkg
            install_package "$pkg"
            ;;
        5) uninstall_package ;;
        6) list_packages ;;
        7) cleanup_brew ;;
        8) show_status ;;
        0) 
            echo -e "${GREEN}$THANKS${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}$INVALID_CHOICE${NC}"
            pause
            ;;
    esac
done

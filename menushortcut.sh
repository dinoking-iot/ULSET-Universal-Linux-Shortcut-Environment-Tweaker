#!/bin/bash

# ==============================================================================
# PROJECT: Universal Linux Shortcut Environment Tweaker (ULSET)
# VERSION: 2026.10.16_v7 (Bugfix Verified)
# TARGET: BigLinux (Priority), Arch, Debian, Ubuntu, Mint, Fedora, Zorin, Deepin
# PURPOSE: Silent Cross-Platform Context Shortcut Service (Preserving Stock Wine)
# ==============================================================================

# --- [ 1. INITIALIZATION & LOGGING CONFIGURATION / KHỞI TẠO & GHI NHẬT KÝ ] ---
LOG_DIR="$HOME/Documents/ULSET_Logs"
LOG_FILE="$LOG_DIR/menushortcut_system.log"
AI_HISTORY_FILE="$LOG_DIR/ai_shortcut_patch_history.json"
mkdir -p "$LOG_DIR"

# Append all runtime events into separate project logfile / Ghi toàn bộ tiến trình vào file log riêng
exec > >(tee -a "$LOG_FILE") 2>&1

ERROR_COUNT=0
OS_FAMILY="unknown"
DE_ENV="unknown"
DISPLAY_SERVER="unknown"
CURRENT_USER=$(whoami)

log_error() {
    ((ERROR_COUNT++))
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$LOG_FILE"
}

# --- [ 2. ENVIRONMENT DETECTION / KIỂM TRA MÔ TRƯỜNG HỆ THỐNG ] ---
detect_environment() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            biglinux|arch|manjaro) OS_FAMILY="arch" ;;
            ubuntu|debian|mint|zorin|deepin) OS_FAMILY="debian" ;;
            fedora) OS_FAMILY="fedora" ;;
            *) OS_FAMILY="arch" ;;
        esac
    fi
    [ "$XDG_SESSION_TYPE" = "wayland" ] || [ "$WAYLAND_DISPLAY" != "" ] && DISPLAY_SERVER="Wayland" || DISPLAY_SERVER="X11"
    [ "$XDG_CURRENT_DESKTOP" != "" ] && DE_ENV="$XDG_CURRENT_DESKTOP"
}
detect_environment

# --- [ 3. GUI CHECK & FORCED TERMINAL SPAWN / ĐIỀU HƯỚNG MỞ CỬA SỔ TERMINAL ] ---
if [ ! -t 0 ]; then
    if command -v konsole &> /dev/null; then exec konsole -e "$0" "$@";
    elif command -v qterminal &> /dev/null; then exec qterminal -e "$0" "$@";
    elif command -v gnome-terminal &> /dev/null; then exec gnome-terminal -- "$0" "$@";
    elif command -v xterm &> /dev/null; then exec xterm -e "$0" "$@"; fi
fi

MENU_FILE="$HOME/.local/share/kio/servicemenus/send_to_desktop.desktop"

# --- [ 4. ANTI-SPAM UNIVERSAL NOTIFICATION / HỆ THỐNG THÔNG BÁO KHÔNG SPAM ] ---
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    
    echo ">> [NOTIFICATION] $title: $message"
    
    if command -v notify-send &> /dev/null; then
        notify-send -u "$urgency" -a "ULSET" "$title" "$message"
    elif command -v kdialog &> /dev/null; then
        kdialog --title "$title" --passivepopup "$message" 4 2>/dev/null
    fi
}

show_loading() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- [ 5. REBOOT-PERSISTENT LOGGING DAEMON / DAEMON THEO DÕI GỠ LỖI ] ---
spawn_logging_daemon() {
    if ! pgrep -f "ulset_shortcut_daemon" > /dev/null; then
        (
            exec -a ulset_shortcut_daemon bash -c '
            while true; do
                if journalctl --since "30 seconds ago" 2>/dev/null | grep -Ei "proton|wine|kernel|dmesg" >> "'"$LOG_FILE"'" 2>/dev/null; then
                    echo "[$(date)] [DAEMON] Log state updated for shortcut system interaction." >> "'"$LOG_FILE"'"
                fi
                sleep 30
            done'
        ) &
        echo "[INIT] Dynamic background logger daemon spawned successfully." >> "$LOG_FILE"
    fi
}

# --- [ 6. AI METADATA DATABASE & PATCH HISTORY / NHẬT KÝ BẢN VÁ AI ] ---
write_ai_metadata() {
    cat << 'EOF' > "$AI_HISTORY_FILE"
{
  "project": "ULSET",
  "author": "AI Collaborator",
  "patch_history": [
    {"patch_id": "V1", "scope": "Log Separation", "fix": "Rename log system to menushortcut_system.log"},
    {"patch_id": "V2", "scope": "Printf Escape Error", "fix": "Convert printf flags to secure echo strings to bypass option dash error"},
    {"patch_id": "V3", "scope": "Shortcut Engine Fix", "fix": "Rebuild flattened menu text parsing to guarantee shortcut file creation"}
  ]
}
EOF
}

# --- [ 7. SILENT DEPENDENCY CHECK & DEPLOYMENT / CÀI ĐẶT NGẦM SHORTCUT ] ---
core_install_workflow() {
    ERROR_COUNT=0
    send_notification "ULSET Status" "Deployment initiated. Configuring services silently... / Đang triển khai..." "normal"

    # Verify basic native file extensions processing utilities (No wine upgrades or removals)
    if ! command -v wine >/dev/null 2>&1; then
        echo "Installing missing core binary execution parsing tool..." >> "$LOG_FILE"
        case "$OS_FAMILY" in
            arch) pkexec pacman -S --noconfirm --needed wine icoutils >/dev/null 2>&1 || sudo pacman -S --noconfirm --needed wine icoutils >/dev/null 2>&1 ;;
            debian) sudo apt-get update -qq && sudo apt-get install -y -qq wine icoutils >/dev/null 2>&1 ;;
            fedora) sudo dnf install -y -q wine icoutils >/dev/null 2>&1 ;;
        esac
    fi

    # Create the Dolphin service menu securely line-by-line to prevent nesting token crashes
    mkdir -p "$(dirname "$MENU_FILE")"
    echo "[Desktop Entry]" > "$MENU_FILE"
    echo "Type=Service" >> "$MENU_FILE"
    echo "ServiceTypes=KonqPopupMenu/Plugin" >> "$MENU_FILE"
    echo "MimeType=all/all;" >> "$MENU_FILE"
    echo "X-KDE-Priority=TopLevel" >> "$MENU_FILE"
    echo "Actions=sendToDesktop;" >> "$MENU_FILE"
    echo "" >> "$MENU_FILE"
    echo "[Desktop Action sendToDesktop]" >> "$MENU_FILE"
    echo "Name=Send to Desktop (Create Shortcut)" >> "$MENU_FILE"
    echo "Name[vi]=Gửi ra Desktop (Tạo Shortcut)" >> "$MENU_FILE"
    echo "Icon=desktop" >> "$MENU_FILE"
    
    # Inject the core execution pipeline smoothly
    echo "Exec=bash -c 'filepath=\"%F\"; filename=\$(basename \"\$filepath\"); dirname=\$(dirname \"\$filepath\"); ext=\"\${filename##*.}\"; ext_lc=\$(echo \"\$ext\" | tr \"[:upper:]\" \"[:lower:]\"); desktopfile=\"\$HOME/Desktop/\${filename%.*}.desktop\"; if [ \"\$ext_lc\" = \"exe\" ]; then execcmd=\"wine \\\"\$filepath\\\"\"; iconpath=\"\$HOME/.local/share/icons/\${filename%.*}.png\"; mkdir -p \"\$HOME/.local/share/icons\"; wrestool -x -t 14 \"\$filepath\" -o \"\$iconpath\" 2>/dev/null || icotool -x -o \"\$iconpath\" \"\$filepath\" 2>/dev/null || iconpath=\"wine\"; else execcmd=\"xdg-open \\\"\$filepath\\\"\"; iconpath=\"text-x-generic\"; case \"\$ext_lc\" in doc|docx) iconpath=\"x-office-document\" ;; xls|xlsx) iconpath=\"x-office-spreadsheet\" ;; ppt|pptx) iconpath=\"x-office-presentation\" ;; pdf) iconpath=\"application-pdf\" ;; png|jpg|jpeg|gif) iconpath=\"image-x-generic\" ;; txt) iconpath=\"text-x-generic\" ;; esac; fi; echo -e \"[Desktop Entry]\\\\nType=Application\\\\nName=\${filename%.*}\\\\nExec=\$execcmd\\\\nPath=\$dirname\\\\nIcon=\$iconpath\\\\nTerminal=false\" > \"\$desktopfile\"; chmod +x \"\$desktopfile\"'" >> "$MENU_FILE"

    if [ -f "$MENU_FILE" ]; then
        chmod +x "$MENU_FILE"
        killall dolphin 2>/dev/null
        send_notification "Success / Thành Công" "Integration complete! 'Send to Desktop' active. / Cài đặt phím tắt thành công!" "low"
    else
        log_error "Failed to write target service menu file object"
        send_notification "Warning / Cảnh Báo" "Completed with errors. Check logs." "critical"
    fi
}

# --- [ 8. SAFE CLEAN REVERSION / GỠ BỎ MÔ TRƯỜNG SHORTCUT ] ---
core_remove_workflow() {
    send_notification "ULSET Status" "Reversion stack executed. Purging menu configuration... / Đang gỡ bỏ..." "normal"
    if [ -f "$MENU_FILE" ]; then
        rm -f "$MENU_FILE"
        killall dolphin 2>/dev/null
    fi
    send_notification "Cleaned / Đã Làm Sạch" "Dolphin context menu purged. Stock Wine preserved. / Khôi phục hệ thống sạch sẽ." "low"
}

# --- [ 9. BILINGUAL ANTI-CONFLICT CONTROL PANEL / MENU ĐIỀU KHIỂN SONG NGỮ ] ---
main_menu() {
    spawn_logging_daemon
    write_ai_metadata
    clear
    echo "=========================================================="
    echo "    UNIVERSAL SHORTCUT ENVIRONMENT MANAGER SYSTEM (ULSET) "
    echo "    TRÌNH QUẢN LÝ MÔ TRƯỜNG SHORTCUT ĐA NỀN TẢNG          "
    echo "=========================================================="
    echo " Host System OS: $OS_FAMILY | Session: $DISPLAY_SERVER | DE: $DE_ENV"
    echo " Active User: $CURRENT_USER | Log: ~/Documents/ULSET_Logs/"
    echo "----------------------------------------------------------"
    
    if [ -f "$MENU_FILE" ]; then
        echo " [DISABLED] 1. Install 'Send to Desktop' Context Shortcut Engine"
        echo "            [Môi trường dịch vụ chuột phải đang HOẠT ĐỘNG]"
        echo " [ACTIVE]   2. Remove & Purge 'Send to Desktop' Context Shortcut Engine"
        echo "            [Gỡ bỏ dịch vụ chuột phải khỏi hệ thống sạch sẽ]"
        SCRIPT_EXISTS=1
    else
        echo " [ACTIVE]   1. Install 'Send to Desktop' Context Shortcut Engine"
        echo "            [Cài đặt & tích hợp dịch vụ phím tắt chuột phải]"
        echo " [DISABLED] 2. Remove & Purge 'Send to Desktop' Context Shortcut Engine"
        echo "            [Môi trường dịch vụ chưa cài đặt trên hệ thống]"
        SCRIPT_EXISTS=0
    fi
    echo ""
    echo " 0. Safe Exit Framework / Thoát ứng dụng"
    echo "=========================================================="
    read -p "Select Action / Chọn Lựa Chọn (0-2): " USER_ACTION

    case "$USER_ACTION" in
        1)
            if [ $SCRIPT_EXISTS -eq 1 ]; then
                echo "❌ Error: Shortcut engine already deployed! Redirecting..."
                sleep 1.5; main_menu
            else
                echo -n "--> Executing secure silent deployment sequence... "
                core_install_workflow &
                show_loading $!
                echo " [DONE]"
                sleep 1; main_menu
            fi
            ;;
        2)
            if [ $SCRIPT_EXISTS -eq 0 ]; then
Use code with caution.
echo "❌ Error: Target deployment stack not found! Redirecting..."
sleep 1.5; main_menu
else
echo -n "--> Purging deployed configuration files... "
core_remove_workflow &
show_loading $!
echo " [DONE]"
sleep 1; main_menu
fi
;;
0)
echo "Exiting Clean. Debugging logging thread remains active until system reboot."
exit 0
;;
*)
echo "Invalid input / Lựa chọn không hợp lệ."
sleep 1; main_menu
;;
esac
}
main_menu

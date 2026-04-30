#!/usr/bin/env bash

# =============================
# Script: monitor-redis.sh
 
# Author:  Thong LT
# =============================

# Thoát ngay lập tức nếu một lệnh thoát với trạng thái khác không.
set -e

# Load cấu hình từ file .env cùng thư mục (nếu có)
if [ -f "$(dirname "$0")/.env" ]; then
    source "$(dirname "$0")/.env"
fi

# git config --global credential.helper store
 

# --- CẤU HÌNH ---
 
DEST_DIR="."
INTERVAL=1800 # 30 phút (1800 giây)
LOG_FILE="${SYNC_LOG_FILE:-/opt/monitor_redis/redis_history.log}"
MAX_LOG_LINES=5000

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}



HEALTH_FAIL_COUNT=0
while true
do
    # Kiểm tra kích thước log và xóa nếu quá dài
    if [ -f "$LOG_FILE" ]; then
        LINE_COUNT=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
        if [ "$LINE_COUNT" -gt "$MAX_LOG_LINES" ]; then
            : > "$LOG_FILE"
            log "Log quá dài ($LINE_COUNT dòng). Đã xóa nội dung log cũ."
        fi
    fi

    # Kiểm tra RAM: Sử dụng thông số Available (Khả dụng) để chống Out of Memory chính xác nhất
    MEM_INFO=$(free -m | awk '/^Mem:/ {printf "RAM Used: %sMB, Available: %sMB / Total: %sMB", $3, $7, $2}')
    log "$MEM_INFO"

    # Lấy dung lượng RAM thực sự CÒN TRỐNG tính bằng MB (Available)
    AVAILABLE_MB=$(free -m | awk '/^Mem:/ {print $7}')

    if [ "$AVAILABLE_MB" -lt 70 ]; then
        docker system prune -f --volumes=false
    fi

    # Nếu RAM Khả dụng dưới 40MB
    if [ "$AVAILABLE_MB" -lt 40 ]; then
        log "CẢNH BÁO CRITICAL: RAM khả dụng chỉ còn ${AVAILABLE_MB}MB (< 50MB). Nguy cơ Out of Memory!"
        log "Đang khởi động lại hệ thống để bảo vệ máy chủ..."
        sleep 5
        reboot
    fi

    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    log ""
    log "Dung lượng ổ đĩa hiện tại: $DISK_USAGE%"
    log ""

    if [ "$DISK_USAGE" -gt 80 ]; then
        log "Dung lượng > 80%, đang dọn dẹp sâu..."
        # Xóa build cache để giải phóng dung lượng lớn
        docker builder prune -f
        # Xóa các image cũ, rác
        docker image prune -f
    else
        log "Ổ cứng vẫn ổn, giữ lại cache để build nhanh."
        # Vẫn nên dọn dẹp nhẹ nhàng các container/network thừa
        docker system prune -f --volumes=false
    fi

    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    log ""
    log "Dung lượng ổ đĩa hiện tại: $DISK_USAGE%"
    log ""

    log "Đợi 30 phút... "
    sleep $INTERVAL
done

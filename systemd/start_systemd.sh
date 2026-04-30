#!/bin/bash

# Kiểm tra và tạo thư mục key (không sync)
if [ ! -d "/opt/monitor_redis" ]; then
    log "Thư mục key '/opt/monitor_redis' không tồn tại. Đang tạo mới..."
    mkdir -p "/opt/monitor_redis"
fi


cp -fv ./monitor-redis.service /etc/systemd/system/
systemctl daemon-reload
systemctl start monitor-redis
systemctl enable monitor-redis # Tự chạy khi khởi động máy
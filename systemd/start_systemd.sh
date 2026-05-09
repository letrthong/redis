#!/bin/bash

# Kiểm tra và tạo thư mục key (không sync)
if [ ! -d "/opt/monitor_redis" ]; then
    log "Thư mục key '/opt/monitor_redis' không tồn tại. Đang tạo mới..."
    mkdir -p "/opt/monitor_redis"
fi


cp -fv ./monitor-redis.service /etc/systemd/system/
cp -fv ./monitor-redis.sh /opt/monitor_redis

systemctl daemon-reload
systemctl enable monitor-redis

systemctl start monitor-redis
systemctl status monitor-redis
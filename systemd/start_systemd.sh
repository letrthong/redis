#!/bin/bash

mkdir -p /opt/monitor_redis
cp -fv ./monitor-redis.service /etc/systemd/system/
systemctl daemon-reload
systemctl start monitor-redis
systemctl enable monitor-redis # Tự chạy khi khởi động máy
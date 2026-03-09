#
 
# 1. Hạ các container xuống
docker compose down

# 3. Kiểm tra dung lượng ổ đĩa
# Lưu ý: Thay "df /" bằng "df /var/lib/docker" nếu bạn dùng phân vùng riêng cho Docker
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo ""
echo "Dung lượng ổ đĩa hiện tại: $DISK_USAGE%"
echo ""

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "Dung lượng > 80%, đang dọn dẹp sâu..."
    # Xóa build cache để giải phóng dung lượng lớn
    docker builder prune -f
    # Xóa các image cũ, rác
    docker image prune -f
else
    echo "Ổ cứng vẫn ổn, giữ lại cache để build nhanh."
    # Vẫn nên dọn dẹp nhẹ nhàng các container/network thừa
    docker system prune -f --volumes=false
fi

DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo ""
echo "Dung lượng ổ đĩa hiện tại: $DISK_USAGE%"
echo ""

# 4. Chạy lại từ image cũ
docker compose up
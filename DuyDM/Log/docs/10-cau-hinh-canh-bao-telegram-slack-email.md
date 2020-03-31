## Ghi chép cấu hình cảnh báo log quan telegram, email, slack

### 1. Telegram

- Tạo bot

Truy cập link trên trình duyệt mở bot Father `https://t.me/BotFather`

![](../images/graylog-canh-bao/Screenshot_995.png)

![](../images/graylog-canh-bao/Screenshot_996.png)

- Lưu lại chỗi token

- Cài đặt plugin telegram trên graylog server

```
cd /usr/share/graylog-server/plugin/
wget https://github.com/irgendwr/TelegramAlert/releases/download/v2.2.0/telegram-alert-2.2.0.jar
```

```
systemctl restart graylog-server
```

- Cấu hình cảnh báo trên web GUI graylog server

Click `Alerts`,  chọn tab `Notifications` => `Get Started` để tạo 1 thông báo mới.

Nhập các trường bắt buộc là `Title`, `Notification Type`, `Choose Legacy Notification` đúng với tham số cấu hình

![](../images/graylog-canh-bao/Screenshot_997.png)

![](../images/graylog-canh-bao/Screenshot_998.png)

![](../images/graylog-canh-bao/Screenshot_999.png)

Nhập `chat ID`, `Bot Token` và URL địa chỉ Web Interface của graylog-server => `Execute Test Notification` để thử nghiệm 1 tin nhắn gửi về group trên telegram.

![](../images/graylog-canh-bao/Screenshot_1000.png)

![](../images/graylog-canh-bao/Screenshot_1001.png)

### 2. Email

- Cài đặt và cấu hình `postfix` trên `graylog-server`






















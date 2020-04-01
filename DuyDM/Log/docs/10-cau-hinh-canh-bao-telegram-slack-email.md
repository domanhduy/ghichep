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

+ Kiểm tra và gỡ bỏ `sendmail`

```
rpm -qa | grep sendmail
```

```
yum remove sendmail*
```

+ Cài đặt postfix

```
yum -y install postfix cyrus-sasl-plain mailx
```

Đặt postfix như MTA mặc định của hệ thống

```
alternatives --set mta /usr/sbin/postfix
```

Nếu xuất hiện trả về output /usr/sbin/postfix has not been configured as an alternative for mta thì thực hiện:

```
alternatives --set mta /usr/sbin/sendmail.postfix
```

```
systemctl restart postfix
systemctl enable postfix
```

+ Chỉnh sửa config của postfix ở file `/etc/postfix/main.cf`

Thêm vào cuối file đoạn cấu hình

```
myhostname = hostname.example.com

relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
```

+ Tạo file thông tin xác thực tài khoản mật khẩu SASL `vi /etc/postfix/sasl_passwd` và thêm thông tin:

```
[smtp.gmail.com]:587 username:password
```

`username` và `password` sẽ thay bằng tài khoản và mật khẩu của email

+ Phân quyền file

```
postmap /etc/postfix/sasl_passwd
chown root:postfix /etc/postfix/sasl_passwd*
chmod 640 /etc/postfix/sasl_passwd*
systemctl reload postfix
```

```
systemctl restart postfix
systemctl enable postfix
```

- Kiểm tra sự hoạt động của postfix

```
echo "Gui mail bang postfix" | mail -s "Mail kiem tra" <địa chỉ email người nhận>
```

![](../images/graylog-canh-bao/Screenshot_1002.png)


- Chỉnh sửa cấu hình trên graylog server, thêm vào cuối file `/etc/graylog/server/server.conf`


```
transport_email_enabled = true
transport_email_hostname = smtp.gmail.com
transport_email_port = 587
transport_email_use_auth = true
transport_email_auth_username = your_mail@gmail.com
transport_email_auth_password = your_password
transport_email_subject_prefix = [graylog]
transport_email_from_email = your_mail@gmail.com
transport_email_use_tls = true
transport_email_use_ssl = false
```

```
systemctl restart graylog-server
```

- Tạo cảnh báo trên web GUI graylog

+ Click `Alert` => `Notifications` => `Create Notification`

![](../images/graylog-canh-bao/Screenshot_1003.png)

Nhập các thông tin

![](../images/graylog-canh-bao/Screenshot_1004.png)

![](../images/graylog-canh-bao/Screenshot_1005.png

```
Mục sender để nhập email gửi đi (người gửi) cũng là email đăng nhập trong graylog-server.  
Email recipient(s) để nhập email của 1 hoặc 1 nhóm người nhận. 
Body Template sẽ là phần body của email khi gửi về. 
```

+ Click `Execute Test Notification` để test thông báo trước, 1 trạng thái trả về là Success: Notification was executed  successfully => thành công => `Create`

![](../images/graylog-canh-bao/Screenshot_1007.png)

![](../images/graylog-canh-bao/Screenshot_1008.png)

![](../images/graylog-canh-bao/Screenshot_1010.png)

### 3. Cấu hình cảnh báo Slack

- Cài đặt plugin trên graylog server

```
cd /usr/share/graylog-server/plugin/
```

Lựa chọn phiên bản phù hợp với graylog server để tải về.

```
https://github.com/graylog-labs/graylog-plugin-slack/releases
```

```
wget https://github.com/graylog-labs/graylog-plugin-slack/releases/download/3.1.0/graylog-plugin-slack-3.1.0.jar
```

```
systemctl restart graylog-server
systemctl status graylog-server
```

- Chuẩn bị Webhook URL

Tạo channel nhận cảnh báo => Truy cập link `https://my.slack.com/services/new/incoming-webhook` lấy Webhook URL.

![](../images/graylog-canh-bao/Screenshot_1011.png)

![](../images/graylog-canh-bao/Screenshot_1012.png)


- Tạo cảnh báo trên web GUI graylog

Click `Alerts` -> `Notification` -> `Create Notification`

![](../images/graylog-canh-bao/Screenshot_1013.png)

Nhập các trường thiết lập cảnh báo slack

![](../images/graylog-canh-bao/Screenshot_1014.png)

![](../images/graylog-canh-bao/Screenshot_1017.png)

![](../images/graylog-canh-bao/Screenshot_1016.png)

Click `Execute Test Notification` để test

![](../images/graylog-canh-bao/Screenshot_1018.png)


### 4. Cấu hình gửi cảnh báo 

-  Cấu hình event cảnh báo 

+ Trên web GUI: Tại `Alerts`  chọn `Event Definitions` => `Create Event Definition`

![](../images/graylog-canh-bao/Screenshot_1019.png)

+ Đặt tên cho cảnh báo và mô tả ngắn về cảnh báo, chọn mức cảnh báo là `Normal` và `Next`

![](../images/graylog-canh-bao/Screenshot_1020.png)

+ Nhập thông tin như trong ảnh => `Next`

![](../images/graylog-canh-bao/Screenshot_1021.png)

```
+ Chọn Condition Type là Filter & Aggregation 
+ Mục Search Query nhập vào truy vấn để lọc ra những bản tin log phù hợp với tiêu chí cảnh báo
+ Chọn Streams là All Messages để search toàn bộ message ( ta có thể tạo 1 streams để lọc 1 bản tin riêng)
+ Đặt thời gian cách mỗi lần tìm kiếm là 1 phút và tìm trong vòng 1 phút cuối cùng. 
```

+ `Event Fields`, là 1 trường bổ sung thông tin về cảnh báo và thêm ngữ cảnh khi cảnh báo => Có thể bỏ qua.

![](../images/graylog-canh-bao/Screenshot_1022.png)

+ Tới `Notification` , click chọn `Add Notification` và chọn các cảnh báo về `Telegram`, `Email`, `Slack` đã tạo trước đó.

![](../images/graylog-canh-bao/Screenshot_1023.png)

+ `Done` để kết thúc

![](../images/graylog-canh-bao/Screenshot_1024.png)

- Thực hiện SSH để xem cảnh báo thành công => Cảnh báo gửi qua 3 kênh.

![](../images/graylog-canh-bao/Screenshot_1025.png)

![](../images/graylog-canh-bao/Screenshot_1026.png)

![](../images/graylog-canh-bao/Screenshot_1027.png)

### 5. Thiết lập cảnh báo khi SSH sai

- ** Cứ ssh sai thì báo **

- Tạo một event 

+Event Details

![](../images/graylog-canh-bao/Screenshot_1028.png)

+Filter & Aggregation

Search Query điền `Fail`

![](../images/graylog-canh-bao/Screenshot_1029.png)

![](../images/graylog-canh-bao/Screenshot_1030.png)

+Fields 

![](../images/graylog-canh-bao/Screenshot_1031.png)

`Set Value From` => Chọn `Template`

`Template` => Điền ${source.ip}

+Notification

![](../images/graylog-canh-bao/Screenshot_1032.png)

- Kiểm tra

![](../images/graylog-canh-bao/Screenshot_1033.png)

**SSH sai 5 lần trong 5 phút thì báo**

- Tạo Grok patterns với log ssh

```
Mar 31 16:39:47 centoslog sshd[25712]: Failed password for invalid user duydm from 10.10.34.20 port 60010 ssh2
```

+Click vào một bản tin ssh => Xem ở phần `message`

![](../images/graylog-canh-bao/Screenshot_1034.png)

![](../images/graylog-canh-bao/Screenshot_1035.png)

+Chọn `Grok pattern` => `Submit`

![](../images/graylog-canh-bao/Screenshot_1036.png)

Đối với bản tin log này, ta sẽ thực hiện Extract ra thành các cột Datetime, Hostname, Acction, User, IP và Port.

Tích chọn `Named captures onl`y để loại bỏ những trường không cần thiết (các trường không được định nghĩa).

![](../images/graylog-canh-bao/Screenshot_1037.png)

Nhập luôn đoạn sau vào ô `Pattern`

```
%{SYSLOGTIMESTAMP: DateTime} %{DATA:Hostname} sshd\[%{INT}\]: %{WORD: Acction} %{DATA} %{WORD: User_ssh} from %{IPV4: IP_ssh} port %{INT: Port} ssh2
```

![](../images/graylog-canh-bao/Screenshot_1039.png)

![](../images/graylog-canh-bao/Screenshot_1040.png)

Đặt tên cho `Extractor` => `Create extractor` để khởi tạo Extract cho bản tin này.

![](../images/graylog-canh-bao/Screenshot_1041.png)

Sau khi Extractor, sử dụng ssh đăng nhập vào server để hiển thị log mới và kiểm tra lại các trường đã extract.

![](../images/graylog-canh-bao/Screenshot_1042.png)

- Sử dụng Grok patterns để tạo SSH streams. 

+Streams từ `field` message

![](../images/graylog-canh-bao/Screenshot_1056.png)

![](../images/graylog-canh-bao/Screenshot_1057.png)

Sau khi chọn Save trong Streams sẽ xuất hiện thêm SSH streams. Click `Manage Rules` để thiết lập các `Rules`.

![](../images/graylog-canh-bao/Screenshot_1058.png)

![](../images/graylog-canh-bao/Screenshot_1059.png)

![](../images/graylog-canh-bao/Screenshot_1060.png)

Làm tương tự thêm như các `rules` dưới

```
Accepted password for .+ from .+
Failed password for .+ from .+
authentication failure; .+
```

![](../images/graylog-canh-bao/Screenshot_1061.png)

![](../images/graylog-canh-bao/Screenshot_1064.png)

![](../images/graylog-canh-bao/Screenshot_1063.png)

SSH sai hoặc đúng sẽ lọc ra được các bản tin đó.

![](../images/graylog-canh-bao/Screenshot_1065.png)

![](../images/graylog-canh-bao/Screenshot_1066.png)

- Sau khi tạo xong SSH streams sử dụng giá trị Failed của trường action_ssh để lấy các log message gửi về khi có đăng nhập thất bại. Tạo event.

![](../images/graylog-canh-bao/Screenshot_1043.png)

+Event Details

![](../images/graylog-canh-bao/Screenshot_1044.png)

+Filter & Aggregation

![](../images/graylog-canh-bao/Screenshot_1068.png)

Định nghĩa tìm những message có chứa cụm từ Failed trong bản tin. Mỗi 30s tìm 1 lần, nếu trong 5 phút mà tìm được nhiều hơn hoặc bằng 5 lần thì sẽ xuất thông báo (gửi cảnh báo qua mail).

![](../images/graylog-canh-bao/Screenshot_1046.png)

+Fields 

Thêm trường lọc ip_ssh

![](../images/graylog-canh-bao/Screenshot_1047.png)

```
${source.ip_ssh}
```

Thêm trường lọc user_ssh

```
${source.user_ssh}
```

![](../images/graylog-canh-bao/Screenshot_1048.png)

![](../images/graylog-canh-bao/Screenshot_1049.png)

+Notification

![](../images/graylog-canh-bao/Screenshot_1050.png)

- Kiểm tra

![](../images/graylog-canh-bao/Screenshot_1069.png)













































































 






























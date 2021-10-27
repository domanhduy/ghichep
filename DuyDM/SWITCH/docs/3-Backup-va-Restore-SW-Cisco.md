## Ghi chép các bước cấu hình backup và restore config switch cisco

### Mục lục

[1. Trên windows](#windows)<br>
[2. Trên Linux](#linux)<br>

<a name="windows"></a>
## I, Sử dụng trên TFPT windows

## 1. Cài đặt FTP server trên Windows server 2012

- Chuẩn bị một windows server 2012

+ Update
+ Sử dụng key
+ Cấu hình tối thiểu: 2 vCPU, 3GB RAM, 50GB Disk.

**Bước 1: Cài đặt FTP server trong IIS**

- Vào `Server Manager` => `Add roles and features` => click đến `Server Roles` chọn vào `Web Server (IIS)` và chọn `Add features`.

![](../images/backup-restore-sw/Screenshot_951.png)

![](../images/backup-restore-sw/Screenshot_952.png)

![](../images/backup-restore-sw/Screenshot_953.png)

![](../images/backup-restore-sw/Screenshot_954.png)

![](../images/backup-restore-sw/Screenshot_955.png)

![](../images/backup-restore-sw/Screenshot_956.png)

![](../images/backup-restore-sw/Screenshot_957.png)

![](../images/backup-restore-sw/Screenshot_958.png)

![](../images/backup-restore-sw/Screenshot_959.png)

![](../images/backup-restore-sw/Screenshot_960.png)

![](../images/backup-restore-sw/Screenshot_961.png)

![](../images/backup-restore-sw/Screenshot_962.png)

- Đợi quá trình cài đặt hoàn tất click vào close

![](../images/backup-restore-sw/Screenshot_963.png)

Reboot server sau khi add `Features` xong.

**Bước 2: Cài đặt AD và tạo user ftp**

- Vào `Server Manager` => `Add roles and features`

![](../images/backup-restore-sw/Screenshot_964.png)

![](../images/backup-restore-sw/Screenshot_965.png)

![](../images/backup-restore-sw/Screenshot_966.png)

![](../images/backup-restore-sw/Screenshot_967.png)

![](../images/backup-restore-sw/Screenshot_968.png)

![](../images/backup-restore-sw/Screenshot_969.png)

![](../images/backup-restore-sw/Screenshot_970.png)

![](../images/backup-restore-sw/Screenshot_971.png)

![](../images/backup-restore-sw/Screenshot_972.png)

![](../images/backup-restore-sw/Screenshot_973.png)

![](../images/backup-restore-sw/Screenshot_974.png)

Reboot server sau khi add `Features` xong.


Nhấp vào `Server Manager` → Mở `Notifications Pane` bằng cách chọn biểu tượng `Notifications` ở phía trên cùng của Server Manager. Từ thông báo liên quan đến cấu hình AD DS (Active Directory Domain Services), hãy bấm `Promote this server to a domain controller`.

![](../images/backup-restore-sw/Screenshot_977.png)

Nhấp vào `Add a new forest` → Chèn tên miền gốc của bạn vào trường `Root domain name`. Trong trường hợp ví dụ này, tên miền gốc sẽ có tên là "chichchich.xyz"

![](../images/backup-restore-sw/Screenshot_978.png)

![](../images/backup-restore-sw/Screenshot_979.png)

![](../images/backup-restore-sw/Screenshot_980.png)

![](../images/backup-restore-sw/Screenshot_981.png)

![](../images/backup-restore-sw/Screenshot_982.png)

![](../images/backup-restore-sw/Screenshot_983.png)

![](../images/backup-restore-sw/Screenshot_984.png)

![](../images/backup-restore-sw/Screenshot_985.png)

Reboot server

- Tạo user, folder FTP và phân quyền

![](../images/backup-restore-sw/Screenshot_986.png)

![](../images/backup-restore-sw/Screenshot_988.png)

![](../images/backup-restore-sw/Screenshot_989.png)

![](../images/backup-restore-sw/Screenshot_990.png)

![](../images/backup-restore-sw/Screenshot_991.png)

![](../images/backup-restore-sw/Screenshot_992.png)

Phân quyền

![](../images/backup-restore-sw/Screenshot_987.png)

![](../images/backup-restore-sw/Screenshot_993.png)

![](../images/backup-restore-sw/Screenshot_994.png)

![](../images/backup-restore-sw/Screenshot_995.png)

![](../images/backup-restore-sw/Screenshot_996.png)


**Bước 3: Tạo FTP site trên IIS**

![](../images/backup-restore-sw/Screenshot_997.png)

![](../images/backup-restore-sw/Screenshot_998.png)

![](../images/backup-restore-sw/Screenshot_999.png)

![](../images/backup-restore-sw/Screenshot_1000.png)

![](../images/backup-restore-sw/Screenshot_1001.png)

Khi đã cấu hình xong quay lại với màn hình `IIS manager` các bạn chọn vào `Authorization Rules` sau đó Click phải vào khoảng trắng chọn add `allow rules`.

![](../images/backup-restore-sw/Screenshot_1002.png)

![](../images/backup-restore-sw/Screenshot_1003.png)

![](../images/backup-restore-sw/Screenshot_1004.png)


Test login FTP

![](../images/backup-restore-sw/Screenshot_1005.png)

Tham khảo

https://adminvietnam.org/cau-hinh-ftp-tren-windows-server-2012/791/

## 1.2. Backup config switch

```
PROVIDER-E8#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
PROVIDER-E8(config)#ip ftp username userftp
PROVIDER-E8(config)#ip ftp password nhap_password
PROVIDER-E8(config)#exit
PROVIDER-E8#copy running-config ftp
Address or name of remote host []? 103.159.50.61
Destination filename [provider-e8-confg]? provider-e8-confg
Writing provider-e8-confg !
6413 bytes copied in 9.538 secs (672 bytes/sec)
PROVIDER-E8#
```

![](../images/backup-restore-sw/Screenshot_1006.png)

![](../images/backup-restore-sw/Screenshot_1007.png)

Nếu không muốn khai báo thông tin user ftp trong config của switch thì sử dụng lệnh

```
CMC-SW-VLAN-E7-U42#copy running-config ftp://userftp:nhap_pass@192.168.90.223
Address or name of remote host [192.168.90.223]?
Destination filename [cmc-sw-vlan-e7-u42-confg]?
Writing cmc-sw-vlan-e7-u42-confg !!!!
16382 bytes copied in 5.201 secs (3150 bytes/sec)
CMC-SW-VLAN-E7-U42#

```

<a name="linux"></a>
## II, Sử dụng trên FPT Linux CentOS

## 2. Cài đặt FTP server trên Linux CentOS

- Chuẩn bị một server CentOS

+ Update
+ Cấu hình tối thiểu: 2 vCPU, 3GB RAM, 50GB Disk.

**Bước 1: Cài đặt FPT server**

- Cài đặt

```
yum install vsftpd -y
systemctl start vsftpd
systemctl enable vsftpd
```


- Tạo user ftp

```
adduser userftp
passwd userftp
```

Nhập password khi được hỏi.

- Add user ftp vừa tạo vào `user_list`

```
echo "userftp" | sudo tee –a /etc/vsftpd/user_list
```

- Tạo thư mục để upload ftp và chỉnh sửa quyền (owner-group-other).

```
mkdir -p /home/userftp
chmod 550 /home/userftp
chmod 750 /home/userftp
sudo chown -R userftp: /home/userftp
```

**Test**

Nếu xuất hiện lỗi `530 permission denied. ftp`

- Chỉnh sửa config SW `/etc/vsftpd/vsftpd.conf`

```
userlist_enable=NO
```

- Nếu xuất hiện lỗi `500 OOPS: could not read chroot() list file:/etc/vsftpd/chroot_list`

Command lại dòng dưới

```
chroot_list_enable=YES
```

- Nếu xuất hiện lỗi `500 OOPS: vsftpd: refusing to run with writable root inside chroot()`

Thêm config

```
echo 'allow_writeable_chroot=YES' >> /etc/vsftpd/vsftpd.conf && systemctl restart vsftpd
```

```
systemctl restart vsftpd
```

## 2.2. Backup config switch

Nếu không muốn khai báo thông tin user ftp trong config của switch thì sử dụng lệnh

```
CMC-SW-VLAN-E7-U42#copy running-config ftp://userftp:nhap_pass@192.168.90.223
Address or name of remote host [192.168.90.223]?
Destination filename [cmc-sw-vlan-e7-u42-confg]?
Writing cmc-sw-vlan-e7-u42-confg !!!!
16382 bytes copied in 5.201 secs (3150 bytes/sec)
CMC-SW-VLAN-E7-U42#
```








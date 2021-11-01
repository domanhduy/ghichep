## Ghi chép một số case vận hành SW Cisco Nexus 3000 C3064

### Mục lục

[1. Backup restore](#coban)<br>
[2. Thay thế một SW trong cặp VPC](#thaythe)<br>
[3. Bổ sung VPC vào một SW chạy đơn](#bosung)<br>

<a name="backup"></a>
## 1. Backup restore

- Chuẩn bị một FPT server

![](../images/van-hanh-sw-nexus-3k/Screenshot_1645.png)

Tham khảo <a href="https://github.com/domanhduy/ghichep/blob/master/DuyDM/SWITCH/docs/3-Backup-va-Restore-SW-Cisco.md" target="_blank">tại đây!</a>

- Backup config SW 

```
copy running-config sftp://userftp:password@172.16.8.19
```

```
ceph-rep01# copy running-config sftp://userftp:password@172.16.8.19
Enter destination filename: [ceph-rep01-running-config]
Enter vrf (If no input, current vrf 'default' is considered): ^C

ceph-rep01# show vrf
VRF-Name                           VRF-ID State   Reason
default                                 1 Up      --
management                              2 Up      --
peer-keepalive-10g                      3 Up      --
ceph-rep01# copy running-config sftp://userftp:password@172.16.8.19
Enter destination filename: [ceph-rep01-running-config]
Enter vrf (If no input, current vrf 'default' is considered): management

userftp@172.16.8.19's password:
Permission denied, please try again.
userftp@172.16.8.19's password:
Permission denied, please try again.
userftp@172.16.8.19's password:
sftp> put  /var/tmp/vsh/ceph-rep01-running-config  ceph-rep01-running-config
Uploading /var/tmp/vsh/ceph-rep01-running-config to /home/userftp/ceph-rep01-running-config
sftp> exit
Copy complete, now saving to disk (please wait)...
ceph-rep01#
```

```
ceph-rep02# show vrf
VRF-Name                           VRF-ID State   Reason
default                                 1 Up      --
management                              2 Up      --
peer-keepalive-10g                      3 Up      --
ceph-rep02# copy running-config sftp://userftp:password@172.16.8.19
Enter destination filename: [ceph-rep02-running-config]
Enter vrf (If no input, current vrf 'default' is considered): management

The authenticity of host '172.16.8.19 (172.16.8.19)' can't be established.
RSA key fingerprint is 4b:69:2e:aa:ad:80:8a:c2:06:39:b3:80:00:dc:56:b8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.8.19' (RSA) to the list of known hosts.
userftp@172.16.8.19's password:
Connected to 172.16.8.19.
sftp> put  /var/tmp/vsh/ceph-rep02-running-config  ceph-rep02-running-config
Uploading /var/tmp/vsh/ceph-rep02-running-config to /home/userftp/ceph-rep02-running-config
/var/tmp/vsh/ceph-rep02-running-config                                                                                                                               100%   11KB  10.7KB/s   00:00
sftp> exit
Copy complete, now saving to disk (please wait)...
ceph-rep02#
```

- Kiểm tra ở FPT server

```
[root@ops3ftp819 userftp]# ls -alh
total 44K
drwxr-x---. 2 userftp userftp 4.0K Oct 27 10:09 .
drwxr-xr-x. 3 root    root    4.0K Oct 27 09:26 ..
-rw-r--r--. 1 userftp userftp   18 Apr  1  2020 .bash_logout
-rw-r--r--. 1 userftp userftp  193 Apr  1  2020 .bash_profile
-rw-r--r--. 1 userftp userftp  231 Apr  1  2020 .bashrc
-rw-r--r--  1 userftp userftp  12K Oct 27 10:08 ceph-rep01-running-config
-rw-r--r--  1 userftp userftp  11K Oct 27 10:09 ceph-rep02-running-config
[root@ops3ftp819 userftp]#
```

<a name="backup"></a>
## 2. Thay thế một SW trong cặp VPC

- Có một cặp SW VPC CEPH-REPLICATE

```
ceph-rep01: 172.16.8.17/20 System version: 6.0(2)U6(10)
ceph-rep02: 172.16.8.18/20 System version: 6.0(2)U2(9Z)
FTP: 172.16.8.19/20 userftp/password
```

![](../images/van-hanh-sw-nexus-3k/Screenshot_1646.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1647.png)


- Đã có 2 file backup của 2 SW trong cặp VPC


- Chuẩn bị một server cùng loại, cùng verion OS.

Cấu hình IP cùng dải con FTP server

- Giả sử `ceph-rep02` down thực hiện restore config `ceph-rep02-running-config` vào con SW mới.

Đứng ở con SW mới

```
copy sftp://172.16.8.19/home/userftp/ceph-rep02-running-config startup-config
reload
```

```
switch# show vrf
VRF-Name                           VRF-ID State   Reason
default                                 1 Up      --
management                              2 Up      --
switch#  copy sftp://172.16.8.19/home/userftp/ceph-rep02-running-config startup-config
Enter vrf (If no input, current vrf 'default' is considered): management
Enter username: userftp

The authenticity of host '172.16.8.19 (172.16.8.19)' can't be established.
ECDSA key fingerprint is SHA256:EdQZMeFKxXcxyR0KATPzZyXZJEDIE2WoHoV9xoOU4Yk.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.8.19' (ECDSA) to the list of known hosts.
userftp@172.16.8.19's password:
sftp> progress
Progress meter enabled
sftp> get   /home/userftp/ceph-rep02-running-config  /tmp/system.cfg
/home/userftp/ceph-rep02-running-config       100%   11KB  10.7KB/s   00:00
sftp> exit
Copying...
Copy complete, now saving to disk (please wait)...
Copy complete.
switch# cop
copp   copy
switch# reload
This command will reboot the system. (y/n)?  [n] y
```

![](../images/van-hanh-sw-nexus-3k/Screenshot_1648.png)

- Cắm lại toàn bộ dây từ con SW lỗi vào con SW mới vừa restore config đúng thứ tự, đúng các port.

+Tình huống 1

Cặp VPC online ok.

Đang gặp hiện tượng SW 01 đang chạy ngon khi cắm dây vào con SW backup thì các port, PO server ở con SW mới up còn con SW 1 suspndByV

Thử reboot con SW 01 => Trạng thái port ở SW 1 ok bình thường. Cặp VPC bình thường.

+Tình huống 1

Cặp VPC online ok.

Ở con SW thay thế cắm dây vào up luôn.

Đường connect bị timeout

CEPH có log

![](../images/van-hanh-sw-nexus-3k/Screenshot_1649.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1650.png)


**Trường hợp thay thế switch secondary**

SW secondary lỗi cụm CEPH không có cảnh báo gì.

=> Thay thế SW secondary

Cặp VPC online ok.

Ở con SW thay thế cắm dây vào up luôn.

Đường connect bị timeout

CEPH có log

```
2021-10-28 08:11:13.360315 mon.ops3ceph01 [WRN] Health check update: Long heartbeat ping times on back interface seen, longest is 55148.923 msec (OSD_SLOW_PING_TIME_BACK)
2021-10-28 08:11:13.360336 mon.ops3ceph01 [WRN] Health check update: Long heartbeat ping times on front interface seen, longest is 54912.397 msec (OSD_SLOW_PING_TIME_FRONT)
```

![](../images/van-hanh-sw-nexus-3k/Screenshot_1651.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1652.png)

Xử lý cụm CEPH

```


systemctl restart ceph-mgr@ops3ceph01
systemctl restart ceph-mgr@ops3ceph02
systemctl restart ceph-mgr@ops3ceph03


systemctl restart ceph-mon@ops3ceph01
systemctl restart ceph-mon@ops3ceph02
systemctl restart ceph-mon@ops3ceph03
```

SW thay thế là SW `secondary` lúc online lên nhận là `primary`

SW gốc là SW `primary` lúc online lên nhận là `secondary`

**Trường hợp thay thế switch primary**

SW primary lỗi cụm CEPH  OK

=> Thay thế SW primary

Cặp VPC online ok.

Ở con SW thay thế cắm dây vào up luôn.

Đường connect bị timeout

CEPH có log

![](../images/van-hanh-sw-nexus-3k/Screenshot_1653.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1654.png)

Chờ một lúc cụm CEPH tự OK.

Lúc đó SW thay thế hiện `primary, operational secondary` còn SW không lỗi `secondary, operational primary`.

Kết luận: Với cặp SW CEPH-REP

- Reboot SW primary thì có timeout các đường rep và có cảnh báo CEPH

Nếu chủ động reboot thì dùng cờ `ceph osd set noout` trước khi reboot. (Đã thử set cờ nhưng cụm vẫn bắn log OSD_SLOW_PING_TIME_BACK, OSD_SLOW_PING_TIME_FRONT)

- Reboot SW secondary thì không có cảnh báo gì bất thường

Nếu chủ động reboot thì dùng cờ `ceph osd set noout` trước khi reboot.

- Thay thế SW secondary đường rep connect bị timeout, CEPH có log lỗi `OSD_SLOW_PING_TIME_FRONT`, `OSD_SLOW_PING_TIME_BACK`.

Nếu chủ động reboot thì dùng cờ `ceph osd set noout` trước khi thay thế.

- Thay thế SW primary đường rep connect bị timeout, CEPH có log lỗi `osd.0 failed`, `Monitor daemon marked osd.1 down, but it is still running` sau tự OK không cần xử lý gì.

Nếu chủ động reboot thì dùng cờ `ceph osd set noout` trước khi thay thế.

**Trường hợp có file backup nhưng không có ftp server online**

Trường hợp có file backup nhưng không có ftp server online sử dụng laptop cài phần phềm FPT server, để file config ở laptop và thực hiện restore.

- Tải Xlight FTP Server (File cài đặt có ở thư mục scripts)

https://www.xlightftpd.com/download.htm

Cài đặt và tạo FPT server

Có thể chuẩn bị 1 laptop cấu hình IP cùng dải mới SW và cài đặt xlight-ftp-server

![](../images/van-hanh-sw-nexus-3k/Screenshot_1655.png)

Cài đặt tạo username/password, đường dẫn vào thư mục chứa file backup

![](../images/van-hanh-sw-nexus-3k/Screenshot_1656.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1657.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1658.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1659.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1660.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1661.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1662.png)

Truy cập test `ftp://172.16.2.168/`

![](../images/van-hanh-sw-nexus-3k/Screenshot_1663.png)

![](../images/van-hanh-sw-nexus-3k/Screenshot_1664.png)

- Restore config SW

```
copy ftp://172.16.2.168/ceph-rep02-running-config startup-config
reload
```

```
switch# copy ftp://172.16.2.168/ceph-rep02-running-config startup-config
Enter vrf (If no input, current vrf 'default' is considered): management
Enter username: userftp
Password:

***** Transfer of file Completed Successfully *****
Copying...
Copy complete, now saving to disk (please wait)...
Copy complete.
switch#
```

![](../images/van-hanh-sw-nexus-3k/Screenshot_1665.png)

<a name="bosung"></a>
## 3. Bổ sung VPC vào một SW chạy đơn

Cụm đang có 01 SW chạy sau một thời gian cần phải bổ sung thêm một switch nữa để chạy HA.

### I, Thông tin về cặp SW

Cisco Nexus3000 C3064PQ Chassis - 48x10G+4x40G

### II, Cấu hình cơ bản trên từng SW

- Đối với SW đang chạy (SW gốc)

Bỏ qua do đã cấu hình chạy rồi

- Đối với SW đang chạy (SW mới)

+ Hostname
+ IP MNGT
+ Password SSH
+ Cắm các dây của mô hình VPC trước, không cắm các dây interface cho server.

### III, Cấu hình HA cho 2 SW

#### 3.1. Cấu hình sử dụng VPC và interface vlan

- Đối với SW đang chạy (SW gốc)

```
sw-goc(config) feature lldp
sw-goc(config) feature vpc
sw-goc(config) feature interface-vlan
sw-goc(config) feature lacp
sw-goc(config) no lldp tlv-select dcbxp
```

- Đối với SW đang chạy (SW bổ sung)

```
sw-bo-sung(config) feature lldp
sw-bo-sung(config) feature vpc
sw-bo-sung(config) feature interface-vlan
sw-bo-sung(config) feature lacp
sw-bo-sung(config) no lldp tlv-select dcbxp
```

Network cụm đang chạy không có gì bất thường.

#### 3.2. Cấu hình peer-keepalive giữa 2 switch - vPC Peer Keepalive Link

`peer-keepalive` là đường đông bộ trạng thái giữa giữa 2 SW sẽ ở trạng thái routed

Cấu hình tạo vrf tại 2 switch

```
sw-goc(config)# vrf context peer-keepalive-10g
```

```
sw-bo-sung(config)# vrf context peer-keepalive-10g
```

- Cấu hình PO cho đường peer-keepalive - Đường 10GB - vPC Peer Keepalive Link

Trên SW1 - gốc: Gom 2 port 45, 46 thành Po 45

```
sw-goc(config)interface port-channel 45
sw-goc(config-if)#description ->vpc-peerlink-keep
sw-goc(config-if)#no shutdown
sw-goc(config-if)#no switchport
sw-goc(config-if)#vrf member peer-keepalive-10g
sw-goc(config-if)#ip address 192.168.45.11/24
sw-goc(config)
```

```
sw-goc(config)# interface Ethernet1/45
sw-goc(config-if)#description ->vpc-peerlink-keep
sw-goc(config-if)#no shutdown
sw-goc(config-if)#no switchport
sw-goc(config-if)#channel-group 45 mode active
```

```
sw-goc(config)# interface Ethernet1/46
sw-goc(config-if)#description ->vpc-peerlink-keep
sw-goc(config-if)#no shutdown
sw-goc(config-if)#no switchport
sw-goc(config-if)#channel-group 45 mode active
```

Trên SW2 - bổ sung: Gom 2 port 45, 46 thành Po 45

```
sw-bo-sung(config)interface port-channel 45
sw-bo-sung(config-if)#description ->vpc-peerlink-keep
sw-bo-sung(config-if)#no shutdown
sw-bo-sung(config-if)#no switchport
sw-bo-sung(config-if)#vrf member peer-keepalive-10g
sw-bo-sung(config-if)#ip address 192.168.45.12/24
sw-bo-sung(config)
```

```
sw-bo-sung(config)# interface Ethernet1/45
sw-bo-sung(config-if)#description ->vpc-peerlink-keep
sw-bo-sung(config-if)#no shutdown
sw-bo-sung(config-if)#no switchport
sw-bo-sung(config-if)#channel-group 45 mode active
```

```
sw-bo-sung(config)# interface Ethernet1/46
sw-bo-sung(config-if)#description ->vpc-peerlink-keep
sw-bo-sung(config-if)#no shutdown
sw-bo-sung(config-if)#no switchport
sw-bo-sung(config-if)#channel-group 45 mode active
```

Network cụm đang chạy không có gì bất thường.

- Cấu hình ip route trên vrf

Trên SW1 - gốc

```
sw-goc(config)# vrf context peer-keepalive-10g
sw-goc(config-vrf)# ip route 0.0.0.0/0 192.168.45.12
```

Trên SW2 - bổ sung

```
sw-bo-sung(config)# vrf context peer-keepalive-10g
sw-bo-sung(config-vrf)# ip route 0.0.0.0/0 192.168.45.11
```

Network cụm đang chạy không có gì bất thường.

#### 3.3. Tạo vpc domain

Trên SW1 - gốc

```
sw-goc(config)# vpc domain 20
sw-goc(config-vpc-domain)# peer-keepalive destination 192.168.45.12 source 192.168.45.11 vrf peer-keepalive-10g
sw-goc(config-vpc-domain)# auto-recovery
```

Trên SW2 - bổ sung

```
sw-bo-sung(config)# vpc domain 20
sw-bo-sung(config-vpc-domain)# peer-keepalive destination 192.168.45.11 source 192.168.45.12 vrf peer-keepalive-10g
sw-bo-sung(config-vpc-domain)# auto-recovery
```

Kiểm tra

```
show vpc peer-keepalive
```

Network cụm đang chạy không có gì bất thường.

#### 3.4. Cấu hình peer-link - Đường 10GB - vPC Peer Link

- Tạo VLAN 53

Trên SW gốc đã có VLAN 53 nên không tạo nữa.

SW2 - bổ sung

```
sw-bo-sung(config)vlan 53
sw-bo-sung(config-vlan)#name ceph-rep

sw-bo-sung(config)# interface Vlan53
sw-bo-sung(config-if)# no shutdown
sw-bo-sung(config-if)# ip address 192.168.53.251/24
```

Network cụm đang chạy không có gì bất thường.

- Đường cho phép traffic switch đi qua, gom các port channel lại.

Trên SW1 - gốc:  Gom 2 port 47,48 thành Po 47

```
sw-goc(config)interface port-channel 47
sw-goc(config-if)description ->vpc-peerlink
sw-goc(config-if)no shutdown
sw-goc(config-if)switchport mode trunk
sw-goc(config-if)switchport trunk allowed vlan 53
sw-goc(config-if)spanning-tree port type network
sw-goc(config-if)vpc peer-link
```

```
sw-goc(config)interface Ethernet1/47
sw-goc(config-if)description ->vpc-peerlink
sw-goc(config-if)no shutdown
sw-goc(config-if)switchport mode trunk
sw-goc(config-if)switchport trunk allowed vlan 53
sw-goc(config-if)channel-group 47 mode active
```

```
sw-goc(config)interface Ethernet1/48
sw-goc(config-if)description ->vpc-peerlink
sw-goc(config-if)no shutdown
sw-goc(config-if)switchport mode trunk
sw-goc(config-if)switchport trunk allowed vlan 53
sw-goc(config-if)channel-group 47 mode active
```

Trên SW2 - bổ sung:  Gom 2 port 47,48 thành Po 47

```
sw-bo-sung(config)interface port-channel 47
sw-bo-sung(config-if)description ->vpc-peerlink
sw-bo-sung(config-if)no shutdown
sw-bo-sung(config-if)switchport mode trunk
sw-bo-sung(config-if)switchport trunk allowed vlan 53
sw-bo-sung(config-if)spanning-tree port type network
sw-bo-sung(config-if)vpc peer-link
```

```
sw-bo-sung(config)interface Ethernet1/47
sw-bo-sung(config-if)description ->vpc-peerlink
sw-bo-sung(config-if)no shutdown
sw-bo-sung(config-if)switchport mode trunk
sw-bo-sung(config-if)switchport trunk allowed vlan 53
sw-bo-sung(config-if)channel-group 47 mode active
```

```
sw-bo-sung(config)interface Ethernet1/48
sw-bo-sung(config-if)description ->vpc-peerlink
sw-bo-sung(config-if)no shutdown
sw-bo-sung(config-if)switchport mode trunk
sw-bo-sung(config-if)switchport trunk allowed vlan 53
sw-bo-sung(config-if)channel-group 47 mode active
```

Network cụm đang chạy không có gì bất thường.

#### 3.5. Cấu hình MTU 9000

SW1 - gốc

Đã cấu hình MTU 9000 rồi nên không cấu hình nữa.

SW2 - bổ sung

```
sw-bo-sung# configure terminal
sw-bo-sung(config)# policy-map type network-qos jumbo
sw-bo-sung(config)# class type network-qos class-default
sw-bo-sung(config)# mtu 9000
sw-bo-sung(config)# system qos
sw-bo-sung(config)# service-policy type network-qos jumbo
```

Network cụm đang chạy không có gì bất thường.

#### 3.6. Cấu hình PO gom 2 port và để connect tới server

SW2 - bổ sung

```
sw-bo-sung(config)# interface port-channel 32
sw-bo-sung(config-if)# description ->CEPH02-bondcephrep
sw-bo-sung(config-if)# switchport access vlan 53
sw-bo-sung(config-if)# no negotiate auto
sw-bo-sung(config-if)# vpc 32
```

```
sw-bo-sung(config)# interface Ethernet1/32
sw-bo-sung(config-if)# description ->CEPH02-p4p2
sw-bo-sung(config-if)# no shutdown
sw-bo-sung(config-if)# switchport mode access
sw-bo-sung(config-if)# switchport access vlan 53
sw-bo-sung(config-if)# channel-group 32 mode active
```

SW1 - gốc

Đang chạy đơn nên cần tạo thêm VPC và bổ sung port đang chạy đơn vào VPC

```
sw-goc(config)# interface port-channel 32
sw-goc(config-if)# description ->CEPH02-bondcephrep
sw-goc(config-if)# switchport access vlan 53
sw-goc(config-if)# no negotiate auto
sw-goc(config-if)# vpc 32
```

```
sw-goc(config)# interface Ethernet1/32
sw-goc(config-if)# description ->CEPH02-p4p2
sw-goc(config-if)# no shutdown
sw-goc(config-if)# switchport mode access
sw-goc(config-if)# switchport access vlan 53
sw-goc(config-if)# channel-group 32 mode active
```

=> Lúc join PO chưa cắm dây bổ sung ở SW bổ sung thì timeout một lúc.

Đối với đừng CEPH-REP xuất hiện cảnh báo `OSD_SLOW_PING_TIME_FRONT`, `OSD_SLOW_PING_TIME_BACK`. Nên sử dụng các cờ trong khi bảo trì.

```
ceph osd set noout
ceph osd set norecover
ceph osd set norebalance
```

=> Cắm các dây vào server.


Cấu hình bonding lại phía server => Phải restart network trên server.







































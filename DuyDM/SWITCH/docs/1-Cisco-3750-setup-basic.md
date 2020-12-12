## Ghi chép các thao tác setup basic SW

### Mục lục

[1. Reset SW Cisco default](#default)<br>
[2. Thiết lập cơ bản](#coban)<br>

<a name="default"></a>
## 1. Reset SW Cisco default

Cắm dây console vào SW và thực hiện cấu hình qua console

Thao tác ở mode `enable`

```
Switch>enable
Switch#
```

```
Switch#del flash:config.text
Switch#del flash:vlan.dat
Switch#wr erase
Switch#reload
```

Xác nhận `confirm` khi có yêu cầu. Reload SW xong là SW về default

![](../images/cisco-3750-setup-basic/Screenshot_932.png)

<a name="coban"></a>
## 2. Thiết lập cơ bản

- Các mode cấu hình của SWITCH01

```
User mode (chế độ user) : Switch>
Enter Privilege mode (vào chế độ đặc quyền): Switch>enable
Privileged mode (chế độ đặc quyền): Switch#
Enter configuration mode (vào chế độ cấu hình): Switch#configure terminal
Global Config mode: Switch(config)#
Vào Interface mode: Switch(config)#interface fa0/1
Interface mode: Switch(config-if)
Return to global configuration (Trở về Global Config): Switch(config-if)exit
Exit Global Config mode (Thoát Global Config): Switch(config)#exit
Return to user mode (Trở về user mode): Switch#disable
Logout (Đăng xuất): Switch>exit
```

- Set time

```
Switch#show clock
```

```
Switch#clock set 15:08:00 11 December 2021
```

![](../images/cisco-3750-setup-basic/Screenshot_933.png)


- Thiết lập hostname

```
Switch#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
Switch(config)#hostname SWITCH01
SWITCH01(config)#
```

- Đặt password (thao tác ở mode cấu hình)

+ Pass enable

```
SWITCH01(config)#enable password Cisco
SWITCH01(config)#enable secret Cisco
```

Pass đặt là `Cisco`

+ Pass console

```
SWITCH01#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
SWITCH01(config)#line console 0
SWITCH01(config-line)#password Cisco
SWITCH01(config-line)#exit
```

Pass đặt là `Cisco`

+ Pass telnet

```
SWITCH01#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
SWITCH01(config)#line vty 0 4
SWITCH01(config-line)#login
SWITCH01(config-line)#password Cisco
SWITCH01(config-line)#exit
SWITCH01(config)#
```

Pass đặt là `Cisco`

- Lưu cấu hình khi khởi động server

```
SWITCH01#copy running-config startup-config
```

- Reload switch

```
SWITCH01#reload
```

- Thiết lập IP để telnet

Về Switch không có cấu hình IP cho port interface mà chỉ có cấu hình cho IP cho interface vlan

Để có thể cấu hình IP Telnet: Cắm dây mạng vào port định set IP SSH, tạo 1 VLAN chuyển cho MNGT, access VLANxxx vào port đó, cấu hình IP cho interface VLANxxx

```
SWITCH01#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
SWITCH01(config)#vlan 40
SWITCH01(config-vlan)#name MNGT
```

```
SWITCH01#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
SWITCH01(config)#interface Gi1/0/48

SWITCH01(config-if)#description ->telnet
SWITCH01(config-if)#no shutdown
SWITCH01(config-if)#switchport mode access
SWITCH01(config-if)#switchport access vlan 40
SWITCH01(config)#exit
```

![](../images/cisco-3750-setup-basic/Screenshot_934.png)

```
SWITCH01#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
SWITCH01(config)#interface vlan 40
SWITCH01(config-if)#ip address 172.16.4.220 255.255.255.0
SWITCH01(config-if)#ip default-gateway 172.16.10.1
SWITCH01(config)#exit
```

`default-gateway` mục đích để từ SW có tể ra được internet (SW với mục đích local có thể không cần kết nối).

![](../images/cisco-3750-setup-basic/Screenshot_935.png)



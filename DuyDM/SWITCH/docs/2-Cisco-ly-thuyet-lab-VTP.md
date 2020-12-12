## Ghi chép các tìm hiểu về lý thuyết, lab VTP

### Mục lục

[I. Lý thuyết về VTP](#lythuyetvtp)<br>
[II. LAB về VTP](#labvtp)<br>


<a name="default"></a>
## I. Lý thuyết về VTP

Ở một mạng nhỏ việc quản lý các VLAN đơn giản và dễ dàng, còn ở một mạng rộng gồm nhiều thành phần việc quản lý các VLAN ở các SWITCH rất phức tạp và khó nếu không có quy hoạch và sử dụng các cấu hình đặc biệt để quản lý và phân phối VLAN.

### 1.1. Tổng quan về VTP

- VTP cấu hình trên thiết bị switch cho phéo người quản lý mạng cấu hình VLAN và chuyển các VLAN đó tới các thiết bị switch khác trong mạng. 

- Switch có thể được cấu hình của một VTP server, VTP client.

- VTP chỉ hiểu các VLAN trong phạm vi VLAN ID từ 1 -> 1005 và không hỗ trợ quản lý các VLAN ngoài phạm vi này.

### 1.2. Tính năng

- Đảm báo tính nhất quán của VLAN trên hệ thống mạng.

- Theo dõi và giám sát tính chính xác của VLAN.

- Tự động cấu hình

- Cấu hình trunking tự động khi một VLAN mới được thêm vào mạng.

### 1.3. Thành phần của VTP

VTP có tính chất tự động nhưng cũng phải được khoanh vùng một cách nhất định.

- `VTP Domain:` bao gồm một hoặc nhiều switch được liên kết với nhau. Tất cả các thiết bị switch trong một domain sẽ chia sẻ chi tiết cấu hình VLAN bằng VTP advertisements. Một router hoặc SW L3 sẽ định nghĩ xác định ranh giới của từng miền.

Các Swich được cấu hình cùng Domain Name được coi là cùng Domain với nhau.

![](../images/lab-vtp/Screenshot_938.png)

- VTP mode

Trong một domain các Switch có thể đảm nhận 1 trong 3 vai trò sau:

``` 
Server: Một domain có thể có nhiều switch mode server
 
Client: chỉ nhận thông tin VlAN từ switch server

Transparent: các VLAN tạo ra sẽ không ảnh hưởng tới Domain trên các Switch
```

![](../images/lab-vtp/Screenshot_939.png)

- VTP Advertisements

Sử dụng để phân phối, truyền gói tin và đồng bộ các cấu hình VLAN trên toàn mạng.

![](../images/lab-vtp/Screenshot_940.png)

- VTP Pruning

Là cơ chế tăng cường băng thông khả dụng, lưu lượng truyền của Switch bằng cách hạn chế flooded traffic vào các đường trunk không cần thiết. Nếu không sử dụng VTP Pruning một switch sẽ làm flood traffic broadcast, multicast, không xác định lên tất cả các đường trunk trong cùng một VTP domain.

Một cách hiểu khác tăng băng thông truyền tải bằng cách hạn chế các broadcast và flood đến các Switch không chứa host thuộc về VLAN đang Broadcast.

![](../images/lab-vtp/Screenshot_941.png)

Như ở ảnh trên SW 4 không có host nào nên không gửi các gói tin VTP sang.

- VTP version

VTP version: có 3 version 1,2 và 3

VTP Version 2 là phiên bản nâng cấp của VTP Version 1.

VTP Version 3 hỗ trợ từ VLAN 1 đến VLAN 4094, trong khi VTP Version 1 và 2 hỗ trợ 1 đến 1001.

Version 1, 2, 3 đều hỗ trợ 1002 đến 1005 (1002 fddi, 1003 token-ring,1004 fddinet, 1005 trnet).

VTP Version 3 chỉ hỗ trợ từ Cisco IOS Release 12.2(33)SXI  trở về sau.

### 1.4. Hoạt động của VTP

![](../images/lab-vtp/Screenshot_942.png)

**Show vtp status command**

```
VTP Version capable             : 1 to 3 - các version VTP mà SW có thể dùng
VTP version running             : 1 - Version VTP hiện tại đang chạy. Mặc định là 1 có thể set là 2.
VTP Domain Name                 :         - đang trống thì chưa thuộc về thằng nào cả.
VTP Pruning Mode                : Disabled
VTP Traps Generation            : Disabled
Device ID                       : 1833.9da7.ea80
Configuration last modified by 0.0.0.0 at 0-0-00 00:00:00     - Thời gian chỉnh sửa VTP gần nhất.
Local updater ID is 172.16.4.221 on interface Vl1 (lowest numbered VLAN interface found) - Interface các bản tin VTP trao đổi qua nhau.

Feature VLAN:
--------------

VTP Operating Mode                : Mode hiện tại cảu VTP
Maximum VLANs supported locally   : Số VLAN hỗ trợ tối đa mà VTP quản lý được 1005
Number of existing VLANs          : Số VLAN đang hoạt động trên SW.
Configuration Revision            : đếm số lần thay đổi các VLAN trên Switch, mỗi khi chuyển domain nó sẽ chuyển về 0. Khi sang VLAN mới nó sẽ chuyển về 0
MD5 digest : Mã checksum config VLAN.
```

- VTP Domains

VTP cho phép tách mạng thành các miền quản lý nhỏ để quản lý VLAN hiệu qua hơn.

Giới hạn mức độ lan truyền các thay đổi cấu hình trong mạng nếu xảy ra lỗi.

VTP domain bao gồm một switch hoặc nhiều switch được kết nối với nhau chia sẻ cùng một VTP domain.

Quảng báo VTP domain: Đối với VTP server hoặc client switch tham giao vào một mạng hỗ trợ VTP phải là một thành phần của mạng có cùng domain. Khi switch ở các vtp domain khác nhau chũng sẽ không trao đổi thông điệp VTP. VTP server quảng bá domain tới tất cả các thiết vị switch. Việc quản bá domain sử dụng 3 thành phần servers, clients, and advertisements. 

![](../images/lab-vtp/Screenshot_943.png)

- VTP Advertising

![](../images/lab-vtp/Screenshot_944.png)

VTP Frame Details

![](../images/lab-vtp/Screenshot_945.png)

+VTP Revision Number

`VTP Revision Number`: Các Switch trong cùng Domain dựa trên Revision number để xác định xem switch có cấu hình mới hơn. Switch có Revision number thấp hơn sẽ học VLAN từ Switch có Revision number cao hơn. 

Chú ý: khi chuyển Switch Server thì Revision sẽ bị chuyển về 0 và sẽ học các Revision number cao hơn (có thể học từ Client).

Số này là một số 32 bit cho biết mức độ sửa đổi của VTP frame, mặc định là 0. Mỗi khi thêm hoặc xóa VLAN, sửa đổi tham số này sẽ tăng lên.

Tham số này quyết định việc switch nào có cấu hình mới hơn switch nào có cấu hình cũ hơn. Đóng vai trog quan trọng và phức tạp trong việc cho phép VTP phân phối và đồng bộ hóa VTP domain và thông tin cấu hình VLAN.

+ Summary Advertisements 

Advertisements về cơ bản chứ VTP domain, revision number hiện tại và chi tiết cấu hình VTP khách. Bản tin quảng bá gủi đi:

```
+ Mỗi 5 phút bỏi VTP server hoặc VTP client để thông báo cho các switch hỗ trợ VTP lân cận về VTP domain, revision number.
+ Ngay sau khi cấu hình được tạo.
+ Subset Advertisements
```

+ Subset Advertisements 

Chứa các thông tin của VLAN, những thay đổi bao gồm: 

```
Creating or deleting a VLAN 
Suspending or activating a VLAN 
Changing the name of a VLAN 
Changing the MTU of a VLAN
```

+ Request Advertisements

Khi một yêu cầu quảng báo được gửi đến một VTP server trong cùng một VTP domain, VTP server sẽ phản hồi bằng cách gửi một bản tin quảng báo tóm tắt (summary advertisement) và sau đó là một bản tin subnet (subset advertisement). Bản tin quảng báo được gửi đi khi:

```
+ VTP domain thay đổi
+ Nhận được bản tin quảng bá VTP từ một switch có revision number lớn hơn nó.
+ Một bản tin quảng bá bị nhỡ.
+ Swich reset lại.
```

![](../images/lab-vtp/Screenshot_946.png)


- VTP Modes









<a name="labvtp"></a>
## II. LAB về VTP

### 2.1. Mô hình VTP server - VTP client

![](../images/lab-vtp/Screenshot_936.png)

SW ở trạng thái mặc định sẽ có các thuộc tính sau

```
VTP Domain Name                 :
VTP Pruning Mode                : Disabled
VTP Traps Generation            : Disabled
VTP Operating Mode                : Server
Configuration Revision            : 1
```

![](../images/lab-vtp/Screenshot_937.png)




















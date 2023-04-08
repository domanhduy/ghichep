# Kiến trúc, thành phần, sự hoạt động của K8s 

### Mục lục

[1. Kiến trúc Kubernetes](#kientruc)<br>
[2. Sự hoạt động giữa các thành phần trong K8s](#suhoatdong)<br>
[3. Kiến trúc Kubernetes HA](#k8sha)<br>

<a name="kientruc"></a>
## 1. Kiến trúc Kubernetes

Kiến trúc Kubernetes cluster tương đối đơn giản, người dùng không bao giờ thao tác trực tiếp với Node, toàn bộ hoạt động quản trị sẽ thao tác với control plane bằng API.

Thuật ngữ `node` được hiểu là các máy chủ `vật lý` hoặc `ảo hóa` có cài đặt `container runtime`.

Thuật ngữ `cluster` được hiểu là cụm các máy chủ có vai trò giống nhau và hoạt động tương tự nhau, có thể thay thế lẫn nhau.

Kiến trúc Kubernetes cluster bao gồm 02 thành phần chính:

```
Control plane (Master Node)
Node (Woker Node)
```

![](../images/2-kien-truc-k8s/kien-truc.png)

![](../images/2-kien-truc-k8s/Screenshot_18.png)

Thông thường sẽ cài đặt sao cho hai thành phần này nằm độc lập nhau.

`Master node`  có thể được gọi là Master, Head, Head node. Còn `Worker node` có một số tên gọi khác như Minion, Node, Worker.

Việc tính toán cấu hình máy chủ của thành phần này là khác nhau. 

```
+ Với Master node thì sẽ sizing sao cho đảm bảo được tính sẵn sàng cao (nhiều hơn 2 máy chủ), và cấu hình để làm sao quản lý được số lượng Worker node hợp lý.  Vì các Worker sẽ giao tiếp với Master để báo cáo cũng như nhận chỉ thị, càng nhiều Worker node thì cấu hình càng phải cao. 

+ Sizing cho Worker node thì đơn giản hơn theo tư tưởng 1 node worker bị down thì tài nguyên ở các node worker còn lại đủ để chạy.
```

### 1.1. Control plane - Master Node

Control plane - Master Node là thành phần điều khiển toàn bộ các hoạt động chung và kiểm soát các container trên node worker.

![](../images/2-kien-truc-k8s/master.png)

Các thành phần chính trên master node bao gồm:

- API-server (kube-apiserver): Là đầu vào của mọi kết nối trong Kubernetes Cluster

```
+ Thành phần tiếp nhận yêu cầu người dùng hoặc ứng dụng khác
+ Sử dụng khi người dùng hoặc ứng dụng khác muốn ra chị thị đối với Kubernetes Cluster
+ Thao tác thông qua API REST
+ Hoạt động trên port 6443 (HTTPS) và 8080 (HTTP).
+ Nằm tại node Master.
+ kube-apiserver được thiết kế mở rộng theo chiều ngang, nó mở rộng bằng cách triển khai trên nhiều instances. Có thể chạy một số instances của kube-apiserver và cân băng traffic giữa các instances.
```

- Controller manager (kube-controller-manager): Thực hiện các công tác điều khiển vòng lặp (control loop). Có rất nhiều thành phần điều khiển nhỏ hơn bên trong như Replication controller, Node controller, Endpoints controller... 

```
+ Thành phần quản lý Kubernetes Cluster, chạy và điều khiển các process.
+ Xử lý các yêu cầu người dùng hoặc ứng dụng khác, bảo đảm các tiến trình, service chạy trong Kubernetes chạy chính xác
+ Về mặt logic, mỗi controller là một quy trình riêng biệt, nhưng để giảm độ phức tạp, tất cả chúng được compile thành một single binary và chạy trong một single process.
+ Sử dụng Port 10252
```

Một số kiểu controllers 

```
+ Node controller: Chịu trách nhiệm thông báo và phản hồi khi các node ngừng hoạt động.

+ Job controller: Theo dõi các Job objects thực hiện task một lần saou đó tạo Pods chạy các task cho đến khi hoàn thành.

+ EndpointSlice controller: Cung cấp liên kết giữa Services and Pods

+ ServiceAccount controller: Tạo default ServiceAccounts cho namespaces mới.
``` 

- Schedule (kube-scheduler): Thực hiện việc lập lịch để chạy ứng dụng trên các Worker node.

```
+ Điều phối các Pods tới các Woker Node. Một pod đươc tạo ra và không assign cho node nào thì kube-scheduler sẽ tính toán chọn một node để chúng chạy trên đó.
+ Các yếu tố quyết định tới scheduling: individual và collective resource requirements, hardware/software/policy constraints, affinity và anti-affinity specifications, data locality, inter-workload interference, và deadlines.
+ Sử dụng Port 10251
```

- Etcd: Lưu trữ thông tin của toàn bộ Kubernetes Cluster. Mặc định sử dụng là etcd. Đối với hệ thống siêu nhỏ có thể thay thế etcd bằng sqlite.

```
+ Database phân tán, sử dụng ghi dữ liệu theo cơ chế key/value trong K8S cluster.
+ Etcd được cài trên node master và lưu tất cả các thông tin trong Cluser.
+ Etcd sử dụng port 2380 để listening từng request và port 2379 để client gửi request tới.
+ Nếu cụm Kubernetes sử dụng etcd làm store thì phải có phương pháp và kế hoạch sao lưu chúng.
```

### Node - Worker Node

Node - Worker Node có vai trò làm môi trường chạy các container ứng dụng người dùng.

![](../images/2-kien-truc-k8s/worker.png)


Worker Node có 3 thành cơ bản:

- `Container runtime`: Môi trường chạy Container, công nghệ thường thấy nhất là Docker. Thực hiện pull image, start và stop container theo chỉ thị từ kubelet

- `kubelet`: Nhận lệnh từ control plane (Master Node), để tạo mới, thao tác tắt bật các Container ứng dụng theo yêu cầu người dùng. Thực hiện tương tác với container runtime để quản trị vòng đời ứng dụng chạy trong container.

Mỗi một agent chạy ở mỗi node trong cluster. Nó chắc chắn containers đang chạy trong một Pod.

kubelet nhận một PodSpecs được cung cấp theo các cơ chế khác nhau và chắc chắn containers đang trong PodSpecs đó là running và healthy. The kubelet không quản lý containers mà không được create bởi Kubernetes.

- `kube-proxy`: Cho phép người dùng truy cập vào các ứng dụng đang chạy trong Kubernetes Cluster (trong môi trường Container). Tương tác với iptables để thiết lập các chính sách truy cập.

kube-proxy là một network proxy chạy trong mỗi node ở cluster. 

kube-proxy duy trì network rules trên nodes. Các network rules cho phép network giao tiếp tới các Pods từ network sessions bên trong hoặc outside cluster.

kube-proxy sử dụng operating system packet filtering layer nếu có và available. Kube-proxy tự forwards traffic.

### Một số thành phần khác

- Addons

Addons sử dụng Kubernetes resources (DaemonSet, Deployment...) để triển khai cluster features.

- DNS

Mặc dù không phải là thành phần bắt buộc nhưng tất cả Kubernetes clusters nen có cluster DNS

Cluster DNS là một DNS server, ngoài các máy chủ DNS khác trong môi trường nó phục vụ DNS records choKubernetes services.

Containers cho Kubernetes start sẽ tự động đưa DNS server này vào để tìm kiếm DNS.

- Web UI (Dashboard)

Dashboard là một giao diện người dùng dựa trên web, có mục đích chung quản lý cluster Kubernetes. Nó cho phép người dùng quản lý và khắc phục sự cố các ứng dụng đang chạy trong cụm, cũng như chính cụm đó.

- Container Resource Monitoring

Ghi lại các time-series metrics chung về các container trong central databas và cung cấp giao diện người dùng để duyệt dữ liệu đó.

- Cluster-level Logging

Lưu container logs vào central log store với giao diện search/browsing.

<a name="suhoatdong"></a>
## 2. Sự hoạt động giữa các thành phần trong K8s

![](../images/2-kien-truc-k8s/master-worker.png)

![](../images/2-kien-truc-k8s/Architecture.png)

Xem hình minh họa để ý chiều các mũi tên

API server chính là nơi giao tiếp giữa các thành phần, gõ lệnh tương tác qua CLI (Command Line Interface) hay qua RESTful API thì cũng phải qua API server.

Từ Worker node, thì kube-proxy và Kubelet gọi tới API server để báo cáo trạng thái cũng như nhận các chỉ thị cần thực hiện.

Bên trong Master node thì chỉ có API server mới có thể tương tác với etcd. 

Có trường hợp Master node kết nối sang Worker node, kết nối từ API server sang Worker node thực hiện khi gửi yêu cầu kết nối tới các container (khi lấy log ở các stdout, hay thực hiện truy cập vào console của container. API server sẽ kết nối tới Kubelet để thực hiện các truy cập vào container)

<a name="k8sha"></a>
## 3. Kiến trúc Kubernetes HA

![](../images/2-kien-truc-k8s/hak8s.png)

### Tham khảo

https://kubernetes.io/docs/concepts/overview/components/











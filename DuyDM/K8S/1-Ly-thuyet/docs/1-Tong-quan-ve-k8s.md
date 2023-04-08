## Tổng quan về Kubernetes K8s

### Mục lục

[1. Kubernetes là gì?](#k8s)<br>
[2. Sự cần thiết của K8s](#ip)<br>



<a name="k8s"></a>
## 1. Kubernetes là gì?

![](../images/1-tong-quan-k8s/kuberneteslogo.png)

`Kubernetes` là có thể hiểu là một giải pháp open source giúp system admin có thể triển khai - phát triển - public - scale - update ứng dụng dưới dạng container dễ dàng và có tính tự động.

Kubernetes còn được gọi là Container Orchestration Engine, là một trong các orchestration tools nằm trong hệ sinh thái của container (công cụ điều phối container). Kubernetes Orchestration cho phép người dùng xây dựng các dịch vụ ứng dụng mở rộng nhiều containers, lên lịch các containers đó trên một cụm máy chủ (cluster), mở rộng các containers và quản lý tình trạng của các containers theo thời gian.

Kubernetes loại bỏ rất nhiều các quy trình thủ công liên quan đến việc triển khai và mở rộng các containerized applications. Các đối tượng thuộc k8s được trừu tượng hóa để dễ dàng quản trị, và toàn bộ thao tác quản lý đều thao tác qua Kubernetes API.

Kubernetes có thể được triển khai trên một hoặc nhiều máy vật lý, máy ảo hoặc cả máy vật lý và máy ảo để tạo thành Kubernetes cluster.

Tên gọi Kubernetes có nguồn gốc từ tiếng Hy Lạp, có ý nghĩa là người lái tàu hoặc hoa tiêu. Google mở mã nguồn Kubernetes từ năm 2014. Kubernetes xây dựng dựa trên một thập kỷ rưỡi kinh nghiệm mà Google có được với việc vận hành một khối lượng lớn workload trong thực tế, kết hợp với các ý tưởng và thực tiễn tốt nhất từ cộng đồng.







### Tham khảo

https://kubernetes.io/vi/docs/concepts/overview/what-is-kubernetes/


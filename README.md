AWS_1_VPC
Networking & Subnetting (AWS VPC Setup)
Explanation

I designed a custom VPC using CIDR 10.0.0.0/16, which provides a large private address space and allows room for subnet expansion in the future.
The network is divided into four /24 subnets: two public and two private. Public subnets are used for internet-facing resources and are connected to an Internet Gateway (IGW).
Private subnets are used for backend or internal services and do not receive public IPs; instead, they use a NAT Gateway placed in a public subnet for secure outbound access.
Separate public and private route tables ensure proper routing and isolation between internet-facing and internal resources.

2. GitHub Repository

GitHub Link: Insert your repository URL here](https://github.com/anushika-tech)

3. Subnet CIDR Ranges Used & Justification

VPC CIDR: 10.0.0.0/16
Provides a large private IP range with flexibility to add more subnets in the future.

Public Subnet 1: 10.0.1.0/24

Public Subnet 2: 10.0.2.0/24
Assigned to internet-facing resources in two different Availability Zones for high availability.

Private Subnet 1: 10.0.3.0/24

Private Subnet 2: 10.0.4.0/24
Used for backend workloads; isolated from direct internet access. /24 provides 256 IPs, which is sufficient and easy to manage for lab or small deployments.

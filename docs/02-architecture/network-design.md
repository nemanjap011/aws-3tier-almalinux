# Network Design

## Overview
This project uses a 3-tier AWS network design implemented with Terraform.

The architecture is structured to separate:
- internet-facing components
- private application components
- private database components

The design uses two Availability Zones to improve resiliency and better reflect production-oriented cloud architecture practices.

---

## Region
- AWS Region: `us-east-1`

---

## VPC
- VPC ID: `vpc-0b744584f568c1f2c`
- VPC CIDR: `10.0.0.0/16`

This VPC provides the address space for all public and private tiers in the environment.

---

## Availability Zones
The network is distributed across:
- `us-east-1a`
- `us-east-1b`

This allows subnets for each major tier to span multiple AZs.

---

## Subnet Layout

### Public Subnets
Used for internet-facing infrastructure such as:
- Application Load Balancer
- NAT Gateway
- other public entry components if required later

| Subnet Name | AZ | CIDR | Subnet ID |
|---|---|---|---|
| public-1 | us-east-1a | 10.0.1.0/24 | subnet-0cfca43c6c5215510 |
| public-2 | us-east-1b | 10.0.2.0/24 | subnet-0d126d772c17b45d7 |

### Application Private Subnets
Used for application servers or services that should not have direct public exposure.

| Subnet Name | AZ | CIDR | Subnet ID |
|---|---|---|---|
| app-private-1 | us-east-1a | 10.0.11.0/24 | subnet-0480700c34ed3471e |
| app-private-2 | us-east-1b | 10.0.12.0/24 | subnet-05210a927f6d7a037 |

### Database Private Subnets
Used for database instances or clusters that should remain isolated from direct internet access.

| Subnet Name | AZ | CIDR | Subnet ID |
|---|---|---|---|
| db-private-1 | us-east-1a | 10.0.21.0/24 | subnet-06606c6ea8772a8e7 |
| db-private-2 | us-east-1b | 10.0.22.0/24 | subnet-0f90b1dc39abe340e |

---

## Internet Connectivity Design

### Internet Gateway
An Internet Gateway is attached to the VPC to allow public subnet internet connectivity.

### NAT Gateway
A NAT Gateway is deployed in the public tier to allow outbound internet access from private application subnets.

- NAT Gateway ID: `nat-0b9d40c71d3dc3120`

At this stage of the project, only one NAT Gateway is deployed. This is acceptable for a development milestone, but it introduces a single-AZ dependency for outbound private subnet internet access. A later milestone may introduce a second NAT Gateway for improved availability.

---

## Route Table Design

### Public Route Table
The public route table contains:
- local VPC route
- default route `0.0.0.0/0` to the Internet Gateway

Associated with:
- public-1
- public-2

### Application Private Route Table
The application private route table contains:
- local VPC route
- default route `0.0.0.0/0` to the NAT Gateway

Associated with:
- app-private-1
- app-private-2

### Database Private Route Table
The database private route table contains:
- local VPC route only

Associated with:
- db-private-1
- db-private-2

This ensures the database tier has no direct internet path.

---

## Traffic Flow Summary

### Inbound Flow
Expected future inbound flow:
- Internet
- Application Load Balancer in public subnets
- application instances in private application subnets

### Outbound Flow from App Tier
Expected outbound flow:
- application instances in private app subnets
- route to NAT Gateway
- internet access for updates, package retrieval, or controlled outbound dependencies

### Database Flow
Expected database traffic flow:
- application tier connects to database tier over private network paths inside the VPC
- no direct public inbound or outbound internet routing for the database tier

---

## Design Decisions
Key design decisions for this milestone:

1. **Environment separation**
   - Terraform execution is environment-based under `env/dev`

2. **Module-based structure**
   - reusable VPC logic is separated into `modules/vpc`

3. **Multi-AZ subnet layout**
   - public, app, and database tiers are all distributed across two AZs

4. **Private database isolation**
   - the DB tier has no direct internet route

5. **Single NAT Gateway for initial milestone**
   - used to keep the first implementation simple while still enabling private app outbound connectivity

---

## Future Improvements
Planned or likely future improvements include:
- second NAT Gateway for higher availability
- dedicated route tables per AZ if needed
- ALB deployment in public subnets
- security groups with explicit app-to-db traffic control
- EC2 deployment in app tier
- database subnet group and database deployment
- observability and alerting components

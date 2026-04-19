# Milestone 02 – Private Compute and Baseline Security

## Objective
Build the private compute layer for the AWS 3-tier AlmaLinux project.

This milestone introduces the first application instances into the environment and establishes the baseline security posture for the app tier.

---

## Scope
Milestone 02 includes:

- 2 EC2 application instances
- one instance in each app private subnet
- no public IP addresses
- IAM role for AWS Systems Manager (SSM)
- instance profile attachment
- security group for application instances
- AlmaLinux user data bootstrap
- validation of private placement and SSM connectivity

Milestone 02 does not include:

- Application Load Balancer
- target groups
- auto scaling
- database deployment
- RDS or PostgreSQL layer
- public application exposure

---

## Implemented Components

### Compute
Two AlmaLinux EC2 instances were deployed into the private application tier.

- App instance 1:
  - Instance ID: `i-06a9c8035e69db5e0`
  - Availability Zone: `us-east-1a`
  - Subnet ID: `subnet-027ac81fd9bea3d1a`
  - Private IP: `10.0.11.116`

- App instance 2:
  - Instance ID: `i-05f7448595d426b7a`
  - Availability Zone: `us-east-1b`
  - Subnet ID: `subnet-01641670f1111b637`
  - Private IP: `10.0.12.71`

### IAM and Management
An IAM role and instance profile were attached to the EC2 instances to allow management through AWS Systems Manager.

- IAM role: `aws-3tier-almalinux-dev-app-ssm-role`
- Instance profile: `aws-3tier-almalinux-dev-app-instance-profile`

### Security
A dedicated application security group was created for the private app tier.

- Security group ID: `sg-079104629e8bb7501`
- Security group name: `aws-3tier-almalinux-dev-app-sg`

Current rule posture:

- Inbound rules: none
- Outbound rules: allow all outbound traffic to `0.0.0.0/0`

### Bootstrap Configuration
Each instance was provisioned with Terraform user data to perform initial operating system bootstrap tasks, including:

- system package update
- installation/start of SSM agent
- hostname assignment
- MOTD creation for instance identification

---

## Design Decisions

### Private-by-default compute placement
The app instances were intentionally placed in private subnets with no public IP addresses. Administrative access is performed through AWS Systems Manager instead of SSH from the public internet.

### Two-AZ placement
One app instance was placed in each private app subnet across two Availability Zones to establish a highly available compute baseline for later milestones.

### Minimal inbound exposure
No inbound rules were configured on the application security group. This keeps the app layer non-addressable from external sources until a controlled frontend path is introduced in a later milestone.

### Temporary broad outbound access
Outbound access is currently open to all destinations. This is acceptable for the current milestone because the instances are private and require outbound access for package installation and SSM communication. Outbound restrictions will be tightened in later milestones as dependencies become explicit.

---

## Validation Evidence

The deployed compute layer was validated using Terraform outputs and AWS CLI checks.

### Terraform Outputs
- VPC ID: `vpc-01b95b3a37eb7a3d0`
- Public subnets:
  - `subnet-02bd81558b37eb188`
  - `subnet-0698a86bbb72049f4`
- App private subnets:
  - `subnet-027ac81fd9bea3d1a`
  - `subnet-01641670f1111b637`
- DB private subnets:
  - `subnet-00a6a9148dd76d2d7`
  - `subnet-03e02bf9a8355c3f0`
- NAT Gateway:
  - `nat-00e5c82a423beffbb`

### Instance Placement Validation
AWS CLI output confirmed:

- both instances are in private subnets
- both instances are in running state
- neither instance has a public IP address

### SSM Validation
AWS CLI output confirmed:

- both instances are registered with Systems Manager
- both instances are online
- platform detected as AlmaLinux

### Security Group Validation
AWS CLI output confirmed:

- no inbound rules exist
- outbound traffic is currently allowed to `0.0.0.0/0`

---

## Milestone Outcome
Milestone 02 completed successfully.

A private compute layer was deployed across two Availability Zones using AlmaLinux EC2 instances in private subnets. The instances have no public IP addresses, are managed through AWS Systems Manager, and are protected by a security group with no inbound access.

This environment is now ready for the next milestone, where controlled traffic flow and higher-level application access patterns can be introduced.
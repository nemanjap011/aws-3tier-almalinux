# Security Model

## Purpose
This document defines the current security model for the AWS 3-tier AlmaLinux Terraform project.

It describes how network isolation, instance access, and baseline security controls are applied across the environment.

---

## Security Principles

### 1. Private-by-default design
Application and database tiers are placed in private subnets.

Only the public tier is intended to have direct internet-facing infrastructure. At the current stage of the project, the app tier is not internet-facing and the DB tier is fully isolated from direct internet access.

### 2. Least exposure
Resources should expose only the minimum required network paths.

Current design goals:

- public tier accepts internet-facing traffic only when required
- app tier does not accept direct public inbound access
- DB tier does not accept direct public inbound access
- management access avoids public SSH exposure

### 3. Controlled administration
Administrative access to app instances is performed through AWS Systems Manager (SSM), not through publicly exposed SSH.

This reduces attack surface and removes the need for public IP addresses on compute instances.

### 4. Segmentation by tier
The infrastructure is segmented into three logical tiers:

- public
- app private
- db private

Each tier has a different trust level and traffic expectation.

---

## Current Network Security Posture

## VPC
- VPC ID: `vpc-01b95b3a37eb7a3d0`
- CIDR: `10.0.0.0/16`

## Public Tier
Public subnets exist to host internet-facing infrastructure in later milestones.

- `subnet-02bd81558b37eb188` in `us-east-1a`
- `subnet-0698a86bbb72049f4` in `us-east-1b`

These subnets route outbound and inbound internet traffic through the Internet Gateway.

## Application Tier
Application instances are deployed in private subnets.

- `subnet-027ac81fd9bea3d1a` in `us-east-1a`
- `subnet-01641670f1111b637` in `us-east-1b`

These subnets do not assign public IP addresses to instances. Outbound traffic is routed through the NAT Gateway.

## Database Tier
Database subnets are private and isolated.

- `subnet-00a6a9148dd76d2d7` in `us-east-1a`
- `subnet-03e02bf9a8355c3f0` in `us-east-1b`

The DB route table does not include a default route to the internet. This means the DB tier remains isolated from direct outbound internet access at the subnet routing level.

---

## Security Groups

### Application Security Group
- Security group ID: `sg-079104629e8bb7501`
- Name: `aws-3tier-almalinux-dev-app-sg`

Current rules:

#### Inbound
- none

#### Outbound
- allow all outbound traffic to `0.0.0.0/0`

### Interpretation
This means the app instances currently:

- cannot be reached directly from external sources
- cannot be reached from other sources unless future inbound rules are added
- can initiate outbound connections through the NAT path

This is acceptable for the current build stage because the instances need outbound connectivity for package installation and Systems Manager registration.

---

## Instance Access Model

### No public IP addresses
The app instances do not have public IP addresses.

Validated instances:

- `i-06a9c8035e69db5e0` → `10.0.11.116`
- `i-05f7448595d426b7a` → `10.0.12.71`

### Systems Manager access
The instances are managed using:

- IAM role: `aws-3tier-almalinux-dev-app-ssm-role`
- Instance profile: `aws-3tier-almalinux-dev-app-instance-profile`

Systems Manager status validated:

- both instances are online
- platform detected as AlmaLinux

This enables secure management without opening inbound SSH.

---

## Instance Hardening Controls

### IMDSv2 enforced
EC2 instance metadata is configured with:

- `http_endpoint = enabled`
- `http_tokens = required`

This enforces IMDSv2 and reduces the risk of metadata abuse.

### Encrypted root volumes
Instance root volumes are configured as:

- encrypted
- `gp3`
- delete on termination enabled

### No public administration path
There is currently no design dependency on:

- public SSH
- bastion host
- direct internet access to app instances

---

## NAT and Egress Model

### NAT Gateway
- NAT Gateway ID: `nat-00e5c82a423beffbb`

The NAT Gateway provides outbound internet access for the app tier without exposing app instances directly to the internet.

### Current egress posture
Current app-tier egress is broad and should be considered temporary.

Present state:
- all outbound traffic allowed

Target later state:
- restrict outbound traffic to required destinations and ports only
- explicitly allow only application dependencies
- explicitly allow DB access once DB security groups are introduced

---

## Planned Security Improvements

The following security improvements are expected in later milestones:

- add ALB-to-app inbound rules only
- add app-to-db rules only on required database ports
- restrict broad outbound rules
- introduce tighter east-west traffic controls
- add logging/monitoring controls
- consider VPC endpoints where appropriate to reduce public egress dependency

---

## Summary
The current environment follows a strong baseline security model for an early-stage cloud deployment:

- private subnets for app and DB tiers
- no public IPs on compute
- SSM-based management
- no inbound access to app instances
- IMDSv2 enforced
- encrypted root storage
- database tier isolated at route level

This is a solid Milestone 02 baseline and is appropriate before introducing load balancing and application traffic in later phases.
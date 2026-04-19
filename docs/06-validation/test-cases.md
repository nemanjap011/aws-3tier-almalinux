# Validation Test Cases

## Purpose
This document records validation checks performed for the AWS 3-tier AlmaLinux Terraform project.

The goal is to verify that each completed milestone matches the intended design and that deployment evidence is captured in a professional, repeatable way.

---

# Milestone 01 – Network Foundation Validation

## Validation Summary
Terraform execution completed successfully and the expected foundational network resources were created and later destroyed after validation.

### Apply Result
- Terraform apply status: Success
- Milestone result: Network foundation deployed successfully

### Destroy Result
- Terraform destroy status: Success
- Destroy result: All Milestone 01 resources removed successfully

---

## Milestone 01 Test Cases

| Test ID | Test Description | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| M01-TC-001 | Run `terraform fmt -recursive` | Terraform files are formatted without error | Command completed successfully | Pass |
| M01-TC-002 | Run `terraform init` | Providers and modules initialize successfully | Initialization completed successfully | Pass |
| M01-TC-003 | Run `terraform validate` | Terraform configuration validates successfully | Validation succeeded | Pass |
| M01-TC-004 | Run `terraform plan` | Terraform generates a valid plan with expected resources | Plan generated successfully with expected VPC, subnet, NAT, IGW, and route resources | Pass |
| M01-TC-005 | Run `terraform apply` | Terraform creates infrastructure successfully | Apply completed successfully and network resources were created | Pass |
| M01-TC-006 | Verify VPC output | VPC ID is returned | `vpc-0b744584f568c1f2c` returned during Milestone 01 validation | Pass |
| M01-TC-007 | Verify public subnet outputs | Two public subnet IDs are returned | `subnet-0cfca43c6c5215510`, `subnet-0d126d772c17b45d7` returned during Milestone 01 validation | Pass |
| M01-TC-008 | Verify app private subnet outputs | Two app private subnet IDs are returned | `subnet-0480700c34ed3471e`, `subnet-05210a927f6d7a037` returned during Milestone 01 validation | Pass |
| M01-TC-009 | Verify DB private subnet outputs | Two DB private subnet IDs are returned | `subnet-06606c6ea8772a8e7`, `subnet-0f90b1dc39abe340e` returned during Milestone 01 validation | Pass |
| M01-TC-010 | Verify NAT Gateway output | NAT Gateway ID is returned | `nat-0b9d40c71d3dc3120` returned during Milestone 01 validation | Pass |
| M01-TC-011 | Verify subnet AZ distribution | Public, app, and DB tiers span `us-east-1a` and `us-east-1b` | Terraform plan confirmed expected AZ distribution | Pass |
| M01-TC-012 | Verify DB subnet isolation design | DB route table has no default route to IGW or NAT | DB private route table designed with only local routing | Pass |
| M01-TC-013 | Verify app private outbound design | App private route table routes outbound traffic through NAT Gateway | NAT route created for app private route table | Pass |
| M01-TC-014 | Run `terraform destroy` after validation | Previously deployed network resources are removed successfully | Destroy completed successfully with all Milestone 01 resources removed | Pass |

---

## Milestone 01 Notes
- Initial Terraform execution under the Windows Documents path caused local `.terraform` directory creation issues.
- Relocating the project to `C:\Projects\aws-3tier-almalinux` resolved the local execution problem.
- The DB subnet design was improved during implementation so that the DB tier spans two Availability Zones.
- Milestone 01 was intentionally destroyed after validation to control cost and keep the workflow clean before the next milestone.

---

# Milestone 02 – Private Compute and Baseline Security Validation

## Validation Summary
Terraform execution completed successfully and the expected private compute resources were created.

The environment now contains:

- 2 AlmaLinux EC2 instances
- one app instance in each private app subnet
- no public IP addresses
- IAM role and instance profile for SSM
- SSM-managed access
- application security group with no inbound rules

---

## Milestone 02 Test Cases

| Test ID | Test Description | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| M02-TC-001 | Run `terraform fmt -recursive` | Terraform files are formatted without error | Command completed successfully | Pass |
| M02-TC-002 | Run `terraform init` after adding new modules | New modules initialize successfully | `compute` and `security` modules initialized successfully | Pass |
| M02-TC-003 | Run `terraform validate` | Terraform configuration validates successfully | Validation succeeded after correcting user data interpolation issue | Pass |
| M02-TC-004 | Run `terraform plan` | Terraform generates a valid plan for security and compute resources | Plan generated successfully for IAM, security group, and EC2 app instances | Pass |
| M02-TC-005 | Run `terraform apply` | Private compute infrastructure is created successfully | Apply succeeded and resources became available in AWS | Pass |
| M02-TC-006 | Verify app instance count | Two app instances are deployed | Two instance IDs returned: `i-06a9c8035e69db5e0`, `i-05f7448595d426b7a` | Pass |
| M02-TC-007 | Verify app instance subnet placement | One app instance is placed in each app private subnet | Instances deployed in `subnet-027ac81fd9bea3d1a` and `subnet-01641670f1111b637` | Pass |
| M02-TC-008 | Verify app instance AZ placement | Instances span two Availability Zones | Instances deployed across `us-east-1a` and `us-east-1b` | Pass |
| M02-TC-009 | Verify no public IPs on app instances | App instances should not have public IPs | AWS CLI confirmed `PublicIp = None` for both instances | Pass |
| M02-TC-010 | Verify private IP assignment | Each app instance has a private IP in the expected subnet range | `10.0.11.116` and `10.0.12.71` assigned | Pass |
| M02-TC-011 | Verify SSM registration | Instances should be visible in Systems Manager | Both instances listed in `aws ssm describe-instance-information` | Pass |
| M02-TC-012 | Verify SSM online status | Instances should report `Online` status in SSM | Both instances reported `PingStatus = Online` | Pass |
| M02-TC-013 | Verify OS platform | Instances should be running AlmaLinux | AWS SSM reported `PlatformName = AlmaLinux` for both instances | Pass |
| M02-TC-014 | Verify IAM role output | App SSM IAM role should be created and exposed via Terraform output | `aws-3tier-almalinux-dev-app-ssm-role` returned | Pass |
| M02-TC-015 | Verify instance profile output | App instance profile should be created and exposed via Terraform output | `aws-3tier-almalinux-dev-app-instance-profile` returned | Pass |
| M02-TC-016 | Verify application security group creation | Dedicated app security group should exist | `sg-079104629e8bb7501` created as `aws-3tier-almalinux-dev-app-sg` | Pass |
| M02-TC-017 | Verify application security group inbound rules | App security group should have no inbound rules | AWS CLI returned `Inbound: []` | Pass |
| M02-TC-018 | Verify application security group outbound rules | App security group should allow outbound traffic | AWS CLI confirmed outbound allow rule to `0.0.0.0/0` | Pass |
| M02-TC-019 | Verify management model | Administrative access should use SSM rather than public SSH | Instances are private and SSM-managed, with no public IP exposure | Pass |

---

## Milestone 02 Output Evidence

### Terraform Output
- VPC ID: `vpc-01b95b3a37eb7a3d0`
- App IAM role: `aws-3tier-almalinux-dev-app-ssm-role`
- App instance profile: `aws-3tier-almalinux-dev-app-instance-profile`
- App security group: `sg-079104629e8bb7501`

### App Instances
- `i-06a9c8035e69db5e0`
  - AZ: `us-east-1a`
  - Subnet: `subnet-027ac81fd9bea3d1a`
  - Private IP: `10.0.11.116`

- `i-05f7448595d426b7a`
  - AZ: `us-east-1b`
  - Subnet: `subnet-01641670f1111b637`
  - Private IP: `10.0.12.71`

### SSM Evidence
- `i-06a9c8035e69db5e0` → `Online` → `AlmaLinux`
- `i-05f7448595d426b7a` → `Online` → `AlmaLinux`

### Security Group Evidence
- Security group ID: `sg-079104629e8bb7501`
- Inbound rules: none
- Outbound rules: allow all outbound traffic to `0.0.0.0/0`

---

## Milestone 02 Notes
- After adding the `compute` and `security` modules, Terraform required a new `terraform init`.
- A Terraform interpolation issue occurred inside EC2 `user_data` because the shell variable name was written in a way Terraform tried to interpret. This was corrected.
- `terraform.tfvars` initially did not include `ami_id` and `app_instance_type`, which caused prompting during plan execution. These values were added to restore a complete non-interactive workflow.
- AlmaLinux AMI selection was completed for `us-east-1` before deployment.
- Current outbound rules are intentionally broad for early-stage functionality and will be tightened in later milestones.

---

## Conclusion
Milestone 01 and Milestone 02 validation completed successfully.

The project now has:

- a validated network foundation
- a private compute layer across two Availability Zones
- SSM-based administration
- no public IP exposure on app instances
- baseline application security group controls

The environment is ready for the next milestone.
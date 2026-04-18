# Validation Test Cases

## Purpose
This document records the validation checks performed for the AWS 3-tier AlmaLinux Terraform project.

The goal is to verify that the infrastructure created in Milestone 01 matches the intended network design.

---

## Validation Summary
Terraform execution completed successfully and the expected foundational network resources were created.

- Terraform apply status: Success
- Resources added: 21
- Resources changed: 0
- Resources destroyed: 0

---

## Test Cases

| Test ID | Test Description | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| TC-001 | Run `terraform fmt -recursive` | Terraform files are formatted without error | Command completed successfully | Pass |
| TC-002 | Run `terraform init` | Providers and modules initialize successfully | Initialization completed successfully | Pass |
| TC-003 | Run `terraform validate` | Terraform configuration validates successfully | Validation succeeded | Pass |
| TC-004 | Run `terraform plan` | Terraform generates a valid plan with expected resources | Plan generated successfully with expected VPC, subnet, NAT, IGW, and route resources | Pass |
| TC-005 | Run `terraform apply` | Terraform creates infrastructure successfully | Apply completed successfully with 21 resources added | Pass |
| TC-006 | Verify VPC output | VPC ID is returned | `vpc-0b744584f568c1f2c` returned | Pass |
| TC-007 | Verify public subnet outputs | Two public subnet IDs are returned | Two subnet IDs returned: `subnet-0cfca43c6c5215510`, `subnet-0d126d772c17b45d7` | Pass |
| TC-008 | Verify app private subnet outputs | Two app private subnet IDs are returned | Two subnet IDs returned: `subnet-0480700c34ed3471e`, `subnet-05210a927f6d7a037` | Pass |
| TC-009 | Verify DB private subnet outputs | Two DB private subnet IDs are returned | Two subnet IDs returned: `subnet-06606c6ea8772a8e7`, `subnet-0f90b1dc39abe340e` | Pass |
| TC-010 | Verify NAT Gateway output | NAT Gateway ID is returned | `nat-0b9d40c71d3dc3120` returned | Pass |
| TC-011 | Verify subnet AZ distribution | Public, app, and DB tiers are distributed across `us-east-1a` and `us-east-1b` | Terraform plan confirmed subnet distribution across both AZs | Pass |
| TC-012 | Verify DB subnet isolation design | DB route table should not include a default route to IGW or NAT | Design implemented with DB private route table containing only local routing | Pass |
| TC-013 | Verify app private outbound design | App private route table should route outbound traffic through NAT Gateway | Route created to NAT Gateway for app private route table | Pass |

---

## Output Evidence

### VPC
- `vpc-0b744584f568c1f2c`

### Public Subnets
- `subnet-0cfca43c6c5215510`
- `subnet-0d126d772c17b45d7`

### App Private Subnets
- `subnet-0480700c34ed3471e`
- `subnet-05210a927f6d7a037`

### DB Private Subnets
- `subnet-06606c6ea8772a8e7`
- `subnet-0f90b1dc39abe340e`

### NAT Gateway
- `nat-0b9d40c71d3dc3120`

---

## Notes
- Initial Terraform execution under the Windows Documents path caused local `.terraform` directory creation issues.
- Relocating the project to `C:\Projects\aws-3tier-almalinux` resolved the local execution problem.
- The DB subnet design was improved during implementation so that the DB tier now spans two Availability Zones.

---

## Conclusion
Milestone 01 validation completed successfully.

The deployed network foundation matches the intended 3-tier design and is ready for the next infrastructure milestone.
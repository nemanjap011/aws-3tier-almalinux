# Milestone 01 - Network Foundation

## Objective
Build the AWS network base for the 3-tier environment:
- 1 VPC
- 2 public subnets
- 2 private app subnets
- 2 private DB subnets
- 1 Internet Gateway
- 1 NAT Gateway
- Public and private route tables
- Route table associations

## Why This Matters
This milestone establishes the base network layout for a production-style 3-tier environment. It enforces tier separation, creates controlled ingress and egress paths, and prepares the project for secure app and database deployment in later milestones.

## Resources Created
The following Terraform-managed AWS resources were successfully created during validation:
- `aws_vpc`
- `aws_subnet` (public)
- `aws_subnet` (app private)
- `aws_subnet` (db private)
- `aws_internet_gateway`
- `aws_eip`
- `aws_nat_gateway`
- `aws_route_table`
- `aws_route`
- `aws_route_table_association`

## Files Added
- `env/dev/main.tf`
- `env/dev/variables.tf`
- `env/dev/terraform.tfvars`
- `env/dev/outputs.tf`
- `env/dev/versions.tf`
- `modules/vpc/main.tf`
- `modules/vpc/variables.tf`
- `modules/vpc/outputs.tf`

## Validation Performed
The following checks were completed successfully:
- `terraform fmt -recursive`
- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`

The deployment completed successfully and produced the following outputs:

- `vpc_id = "vpc-0b744584f568c1f2c"`
- `public_subnet_ids = ["subnet-0cfca43c6c5215510", "subnet-0d126d772c17b45d7"]`
- `app_private_subnet_ids = ["subnet-0480700c34ed3471e", "subnet-05210a927f6d7a037"]`
- `db_private_subnet_ids = ["subnet-06606c6ea8772a8e7", "subnet-0f90b1dc39abe340e"]`
- `nat_gateway_id = "nat-0b9d40c71d3dc3120"`

## Deployment Result
Terraform apply completed successfully with:

- `Apply complete! Resources: 21 added, 0 changed, 0 destroyed.`

This confirmed that the network foundation was deployed correctly in AWS and that Terraform state and outputs were working as expected.

## Teardown Performed
After validation and documentation, the environment was intentionally destroyed to avoid unnecessary AWS cost and to demonstrate full infrastructure lifecycle control.

The following command was executed successfully:
- `terraform destroy`

Teardown result:
- `Destroy complete! Resources: 21 destroyed.`

## Outcome
Milestone 01 is complete.

This milestone proved that the project can:
- provision a production-style AWS network with Terraform
- validate the infrastructure through Terraform workflow
- document real deployment evidence
- destroy the environment cleanly after testing

## Notes
Important operational takeaway:
- infrastructure should not be left running without purpose
- destroy after validation is part of disciplined Cloud / SRE practice
- the value of the project is in reproducible code, documented validation, and controlled teardown
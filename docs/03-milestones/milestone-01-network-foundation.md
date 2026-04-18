# Milestone 01 – Network Foundation

## Objective
Build the foundational AWS network layer for the project using Terraform with a modular structure and environment-based organization.

This milestone establishes the base infrastructure required for the later deployment of:
- public-facing entry components
- private application tier components
- private database tier components

The goal is to create a clean, reusable, and professionally structured Terraform foundation that reflects real-world cloud engineering practices.

---

## Scope
This milestone includes:

- 1 VPC
- 2 public subnets across 2 Availability Zones
- 2 private application subnets across 2 Availability Zones
- 2 private database subnets across 2 Availability Zones
- 1 Internet Gateway
- 1 NAT Gateway
- public and private route table design
- Terraform module structure for the VPC layer
- environment-specific Terraform execution from `env/dev`

This milestone does **not** include:
- EC2 instances
- load balancers
- security groups beyond default VPC creation behavior
- RDS or self-managed PostgreSQL deployment
- IAM roles
- monitoring or alerting

---

## Terraform Structure
The network foundation was implemented using the following structure:

    aws-3tier-almalinux/
    ├── docs/
    ├── env/
    │   └── dev/
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── terraform.tfvars
    │       ├── variables.tf
    │       └── versions.tf
    └── modules/
        └── vpc/
            ├── main.tf
            ├── outputs.tf
            └── variables.tf

This structure separates:
- reusable infrastructure logic in `modules`
- environment-specific execution in `env/dev`
- project documentation in `docs`

---

## Design Summary
The network was designed with three tiers:

### Public tier
Used for internet-facing components and outbound access infrastructure.
- public subnet in `us-east-1a`
- public subnet in `us-east-1b`
- Internet Gateway attached to the VPC
- NAT Gateway deployed in one public subnet

### Application tier
Used for private application servers that should not be directly exposed to the internet.
- private application subnet in `us-east-1a`
- private application subnet in `us-east-1b`
- outbound internet access through NAT Gateway

### Database tier
Used for database components isolated from direct internet access.
- private database subnet in `us-east-1a`
- private database subnet in `us-east-1b`
- no direct internet route

---

## Implementation Notes
A modular Terraform approach was used to keep the project maintainable and extensible.

The VPC module provisions:
- VPC
- subnets
- Internet Gateway
- NAT Gateway
- route tables
- route table associations

The environment layer under `env/dev` provides:
- provider configuration
- environment-specific variable values
- module invocation
- outputs

During implementation, the database subnet design was corrected so that DB subnets are distributed across both Availability Zones instead of being pinned to a single AZ.

---

## Deployment Commands Executed
The following Terraform commands were executed successfully from `env/dev`:

    terraform fmt -recursive
    terraform init
    terraform validate
    terraform plan
    terraform apply

Terraform apply completed successfully with the following result:

- Resources added: 21
- Resources changed: 0
- Resources destroyed: 0

---

## Deployed Resource Inventory

### VPC
- VPC ID: `vpc-0b744584f568c1f2c`
- CIDR: `10.0.0.0/16`

### Public Subnets
- `subnet-0cfca43c6c5215510` → `10.0.1.0/24` → `us-east-1a`
- `subnet-0d126d772c17b45d7` → `10.0.2.0/24` → `us-east-1b`

### Application Private Subnets
- `subnet-0480700c34ed3471e` → `10.0.11.0/24` → `us-east-1a`
- `subnet-05210a927f6d7a037` → `10.0.12.0/24` → `us-east-1b`

### Database Private Subnets
- `subnet-06606c6ea8772a8e7` → `10.0.21.0/24` → `us-east-1a`
- `subnet-0f90b1dc39abe340e` → `10.0.22.0/24` → `us-east-1b`

### NAT Gateway
- NAT Gateway ID: `nat-0b9d40c71d3dc3120`

---

## Validation Outcome
The milestone was considered successful based on the following checks:

- VPC `vpc-0b744584f568c1f2c` created successfully
- Public subnet `subnet-0cfca43c6c5215510` created in `us-east-1a`
- Public subnet `subnet-0d126d772c17b45d7` created in `us-east-1b`
- Application private subnet `subnet-0480700c34ed3471e` created in `us-east-1a`
- Application private subnet `subnet-05210a927f6d7a037` created in `us-east-1b`
- Database private subnet `subnet-06606c6ea8772a8e7` created in `us-east-1a`
- Database private subnet `subnet-0f90b1dc39abe340e` created in `us-east-1b`
- NAT Gateway `nat-0b9d40c71d3dc3120` created successfully
- route table associations created successfully
- Terraform outputs returned expected resource IDs
- Terraform configuration validated successfully before apply

---

## Resulting Terraform Outputs

    vpc_id = "vpc-0b744584f568c1f2c"

    public_subnet_ids = [
      "subnet-0cfca43c6c5215510",
      "subnet-0d126d772c17b45d7",
    ]

    app_private_subnet_ids = [
      "subnet-0480700c34ed3471e",
      "subnet-05210a927f6d7a037",
    ]

    db_private_subnet_ids = [
      "subnet-06606c6ea8772a8e7",
      "subnet-0f90b1dc39abe340e",
    ]

    nat_gateway_id = "nat-0b9d40c71d3dc3120"

---

## Key Lessons Learned
- Terraform execution should always be run from the environment directory that contains the active `.tf` files.
- Windows protected or synced user folders can interfere with Terraform’s `.terraform` working directory creation.
- Moving the working project to `C:\Projects\...` resolved local execution issues.
- It is important to validate architecture symmetry early. The original single-AZ DB subnet design was functional for a lab but not appropriate for a professional multi-tier layout.
- Saving project documentation during the build process makes the final delivery much stronger and easier to explain in interviews.

---

## Next Milestone
The next milestone will build on this network foundation by adding the next infrastructure layer, likely one of the following:
- security groups and controlled traffic flows
- EC2 instances for app and bastion/admin access
- ALB and target group layer
- database deployment layer

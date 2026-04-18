variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "app_private_subnet_cidrs" {
  description = "CIDRs for private app subnets"
  type        = list(string)
}

variable "db_private_subnet_cidrs" {
  description = "CIDRs for private DB subnets"
  type        = list(string)
}
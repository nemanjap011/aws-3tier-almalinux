variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "app_private_subnet_cidrs" {
  type = list(string)
}

variable "db_private_subnet_cidrs" {
  type = list(string)
}
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_ids" {
  type = list(string)

  validation {
    condition     = length(var.subnet_ids) == 2
    error_message = "Milestone 02 requires exactly two app private subnet IDs."
  }
}

variable "security_group_ids" {
  type = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group ID must be provided."
  }
}

variable "instance_profile_name" {
  type = string
}

variable "root_volume_size" {
  type    = number
  default = 20
}
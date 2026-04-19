output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "app_private_subnet_ids" {
  value = module.vpc.app_private_subnet_ids
}

output "db_private_subnet_ids" {
  value = module.vpc.db_private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "app_security_group_id" {
  value = module.security.app_security_group_id
}

output "app_instance_profile_name" {
  value = module.security.instance_profile_name
}

output "app_iam_role_name" {
  value = module.security.iam_role_name
}

output "app_instance_ids" {
  value = module.compute.instance_ids
}

output "app_private_ips" {
  value = module.compute.private_ips
}

output "app_instance_subnet_ids" {
  value = module.compute.subnet_ids
}

output "app_instance_azs" {
  value = module.compute.availability_zones
}
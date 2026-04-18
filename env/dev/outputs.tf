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
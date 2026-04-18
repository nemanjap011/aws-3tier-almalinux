output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "app_private_subnet_ids" {
  value = aws_subnet.app_private[*].id
}

output "db_private_subnet_ids" {
  value = aws_subnet.db_private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}
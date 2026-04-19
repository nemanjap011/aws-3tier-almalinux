output "instance_ids" {
  value = aws_instance.app[*].id
}

output "private_ips" {
  value = aws_instance.app[*].private_ip
}

output "subnet_ids" {
  value = aws_instance.app[*].subnet_id
}

output "availability_zones" {
  value = aws_instance.app[*].availability_zone
}
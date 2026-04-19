resource "aws_instance" "app" {
  count = length(var.subnet_ids)

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index]
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = false
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOT
#!/bin/bash
set -euxo pipefail

dnf -y update
dnf -y install curl unzip

SSM_RPM_URL="https://s3.${var.aws_region}.amazonaws.com/amazon-ssm-${var.aws_region}/latest/linux_amd64/amazon-ssm-agent.rpm"
dnf -y install "$${SSM_RPM_URL}" || true

systemctl enable amazon-ssm-agent || true
systemctl start amazon-ssm-agent || true

hostnamectl set-hostname ${var.project_name}-${var.environment}-app-${count.index + 1}

printf "%s\n" \
  "${var.project_name} ${var.environment} app instance ${count.index + 1}" \
  "Milestone 02 bootstrap complete" \
  "Managed by Terraform" \
  > /etc/motd
EOT

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Role        = "app"
  }
}
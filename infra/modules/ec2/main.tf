# -------------------------------------------------------------
# AMI Data Source: Amazon Linux 2023
# -------------------------------------------------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------------------------------------------------
# Security Group
# -------------------------------------------------------------
resource "aws_security_group" "utility_sg" {
  name        = "${var.name_prefix}-utility-sg"
  description = "Security group for Utility EC2 instance"
  vpc_id      = var.vpc_id

  # Inbound Rules:
  # Locked down by default. SSH allowed only if CIDR provided.
  dynamic "ingress" {
    for_each = length(var.allow_ssh_cidr) > 0 ? [1] : []
    content {
      description = "Allow SSH from specific CIDRs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allow_ssh_cidr
    }
  }

  # Outbound Rules:
  # Allow all outbound traffic (updates, installing packages)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-utility-sg"
    }
  )
}

# -------------------------------------------------------------
# EC2 Instance
# -------------------------------------------------------------
resource "aws_instance" "utility" {
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Associate public IP if in public subnet (exam requirement usually implies access)
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.utility_sg.id]
  key_name               = var.key_name

  # User Data: Minimal setup
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y curl jq
              EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-utility"
      Role = "Utility"
    }
  )

  # Encryption ensures security compliance
  root_block_device {
    encrypted = true
  }
}

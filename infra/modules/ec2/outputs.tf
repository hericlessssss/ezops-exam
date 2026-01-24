output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.utility.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.utility.public_ip
}

output "security_group_id" {
  description = "The ID of the security group created for the EC2 instance"
  value       = aws_security_group.utility_sg.id
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = aws_instance.utility.ami
}

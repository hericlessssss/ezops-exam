variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be placed"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "allow_ssh_cidr" {
  description = "List of CIDR blocks to allow SSH access. Leave empty to block SSH."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Name of the SSH Key Pair to use (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

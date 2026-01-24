variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# resource "aws_db_instance" "postgres" { ... }
# resource "aws_db_subnet_group" "default" { ... }

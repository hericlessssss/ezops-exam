variable "repo_names" {
  description = "List of Docker repository names to create"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# resource "aws_ecr_repository" "repo" { count = length(var.repo_names) ... }

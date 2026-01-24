variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "repo_names" {
  description = "List of repository name suffixes (e.g. ['backend', 'frontend'])"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

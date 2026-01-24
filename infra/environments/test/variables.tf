variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "hrclsfss"
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    Project = "ezops-exam"
    Owner   = "chico"
    Env     = "test"
  }
}

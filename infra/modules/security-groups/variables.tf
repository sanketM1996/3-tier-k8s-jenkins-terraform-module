variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "alb_ingress_cidr" {
  description = "CIDR allowed to access ALB"
  type        = list(string)

  default = [
    "0.0.0.0/0"
  ]
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
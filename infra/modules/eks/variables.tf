variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private application subnet IDs"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  type        = string
}

variable "node_role_arn" {
  description = "EKS node IAM role ARN"
  type        = string
}

variable "node_security_group_id" {
  description = "EKS node security group ID"
  type        = string
}

variable "cluster_security_group_id" {
  description = "Optional additional cluster security group"
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)

  default = [
    "t3.medium"
  ]
}

variable "node_capacity_type" {
  description = "Node capacity type"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Node root disk size"
  type        = number
  default     = 30
}

variable "enable_cluster_logs" {
  description = "Enable EKS control plane logging"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
variable "ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Pod Identity"
  type        = string
}
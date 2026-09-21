output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "alb_security_group_name" {
  description = "ALB security group name"
  value       = aws_security_group.alb.name
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID"
  value       = aws_security_group.eks_node.id
}

output "eks_node_security_group_name" {
  description = "EKS node security group name"
  value       = aws_security_group.eks_node.name
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "rds_security_group_name" {
  description = "RDS security group name"
  value       = aws_security_group.rds.name
}
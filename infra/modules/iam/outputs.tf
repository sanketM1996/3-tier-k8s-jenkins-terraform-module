output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_cluster_role_name" {
  description = "EKS cluster IAM role name"
  value       = aws_iam_role.eks_cluster.name
}

output "node_role_arn" {
  description = "EKS node IAM role ARN"
  value       = aws_iam_role.eks_node.arn
}

output "node_role_name" {
  description = "EKS node IAM role name"
  value       = aws_iam_role.eks_node.name
}

output "ebs_csi_role_arn" {
  description = "EBS CSI IAM role ARN"
  value       = aws_iam_role.ebs_csi.arn
}

output "ebs_csi_role_name" {
  description = "EBS CSI IAM role name"
  value       = aws_iam_role.ebs_csi.name
}

output "alb_controller_role_arn" {
  description = "AWS Load Balancer Controller IAM role ARN"
  value       = aws_iam_role.alb_controller.arn
}

output "alb_controller_role_name" {
  description = "AWS Load Balancer Controller IAM role name"
  value       = aws_iam_role.alb_controller.name
}

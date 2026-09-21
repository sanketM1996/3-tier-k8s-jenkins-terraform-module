output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  value = module.vpc.private_db_subnet_ids
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}


output "eks_cluster_role_arn" {
  value = module.iam.eks_cluster_role_arn
}

output "node_role_arn" {
  value = module.iam.node_role_arn
}

output "ebs_csi_role_arn" {
  value = module.iam.ebs_csi_role_arn
}

output "alb_controller_role_arn" {
  value = module.iam.alb_controller_role_arn
}
output "alb_security_group_id" {
  value = module.security_groups.alb_security_group_id
}

output "eks_node_security_group_id" {
  value = module.security_groups.eks_node_security_group_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_security_group_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  value = module.eks.cluster_version
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}
output "alb_controller_service_account" {
  value = module.alb_controller.service_account_name
}

output "alb_controller_namespace" {
  value = module.alb_controller.namespace
}

output "alb_controller_helm_release" {
  value = module.alb_controller.helm_release_name
}

output "alb_controller_version" {
  value = module.alb_controller.helm_release_version
}
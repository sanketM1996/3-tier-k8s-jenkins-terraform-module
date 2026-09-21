output "service_account_name" {
  value = kubernetes_service_account_v1.alb_controller.metadata[0].name
}

output "namespace" {
  value = kubernetes_service_account_v1.alb_controller.metadata[0].namespace
}

output "pod_identity_association_id" {
  value = aws_eks_pod_identity_association.alb_controller.association_id
}

output "helm_release_name" {
  value = helm_release.alb_controller.name
}

output "helm_release_version" {
  value = helm_release.alb_controller.version
}
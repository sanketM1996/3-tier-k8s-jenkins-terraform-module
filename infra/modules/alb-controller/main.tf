data "aws_region" "current" {}

resource "kubernetes_service_account_v1" "alb_controller" {
  metadata {
    name      = var.service_account_name
    namespace = var.controller_namespace

    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
  }
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = var.cluster_name
  namespace       = var.controller_namespace
  service_account = var.service_account_name
  role_arn        = var.alb_controller_role_arn
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version

  namespace        = var.controller_namespace
  create_namespace = false

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "region"
      value = data.aws_region.current.region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = var.service_account_name
    }
  ]

  depends_on = [
    aws_eks_pod_identity_association.alb_controller
  ]
}
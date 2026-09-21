# =========================================================
# EKS CLUSTER
# =========================================================

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = var.enable_cluster_logs ? [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ] : []

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}


# =========================================================
# EKS MANAGED NODE GROUP
# =========================================================

resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.project_name}-${var.environment}-ng"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types

  capacity_type = var.node_capacity_type

  disk_size = var.disk_size

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    Environment = var.environment
    Project     = var.project_name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-group"
    }
  )

  depends_on = [
    aws_eks_cluster.this
  ]
}


# =========================================================
# VPC CNI
# =========================================================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.this
  ]

  tags = var.tags
}


# =========================================================
# COREDNS
# =========================================================

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.this
  ]

  tags = var.tags
}


# =========================================================
# KUBE PROXY
# =========================================================

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.this
  ]

  tags = var.tags
}


# =========================================================
# EBS CSI DRIVER - POD IDENTITY ASSOCIATION
# =========================================================

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"

  role_arn = var.ebs_csi_role_arn

  depends_on = [
    aws_eks_node_group.this
  ]
}
# =========================================================
# EBS CSI DRIVER
# =========================================================

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.this,
    aws_eks_pod_identity_association.ebs_csi
  ]

  tags = var.tags
}
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.this
  ]

  tags = var.tags
}

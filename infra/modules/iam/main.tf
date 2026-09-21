# EKS Cluster Role
# Trust policy
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "eks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}
# Role
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-cluster-role"
    }
  )
}
# Attach AWS managed policy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
# EKS Node Role
# Trust policy
data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}
# Role
resource "aws_iam_role" "eks_node" {
  name = "${var.project_name}-${var.environment}-eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-role"
    }
  )
}
# Attach Node Policies
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
# ECR Read Only
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}
# CNI Policy
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
# EBS CSI Driver Role
# Trust policy
data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}
# Role
resource "aws_iam_role" "ebs_csi" {
  name = "${var.project_name}-${var.environment}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-ebs-csi-role"
    }
  )
}
# Attach EBS CSI policy
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
# AWS Load Balancer Controller Role
# Trust policy
data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}
# Role
resource "aws_iam_role" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-controller-role"
    }
  )
}
# ALB Policy
resource "aws_iam_policy" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller-policy"

  description = "IAM policy for AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "iam:CreateServiceLinkedRole"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
          }
        }
      },

      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeCoipPools",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSecurityGroupRules"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "wafv2:ListWebACLs",
          "wafv2:ListResourcesForWebACL"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "shield:GetSubscriptionState",
          "shield:DescribeProtection",
          "shield:CreateProtection",
          "shield:DeleteProtection"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ]

        Resource = "*"
      }
    ]
  })

  tags = var.tags
}
# Attach ALB policy
resource "aws_iam_role_policy_attachment" "alb_controller" {
  role = aws_iam_role.alb_controller.name

  policy_arn = aws_iam_policy.alb_controller.arn
}
# =========================================================
# ALB SECURITY GROUP
# =========================================================

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )
}


resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS traffic from internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


# =========================================================
# EKS NODE SECURITY GROUP
# =========================================================

resource "aws_security_group" "eks_node" {
  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-sg"
    }
  )
}


resource "aws_vpc_security_group_ingress_rule" "eks_from_alb_http" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow HTTP traffic from ALB"

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "eks_from_alb_8080" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow application traffic from ALB"

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "eks_node_to_node" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow node-to-node communication"

  referenced_security_group_id = aws_security_group.eks_node.id

  from_port   = 0
  to_port     = 65535
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "eks_node_to_node_udp" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow node-to-node UDP communication"

  referenced_security_group_id = aws_security_group.eks_node.id

  from_port   = 0
  to_port     = 65535
  ip_protocol = "udp"
}


resource "aws_vpc_security_group_ingress_rule" "eks_dns_udp" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow DNS UDP"

  cidr_ipv4 = var.vpc_cidr

  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
}


resource "aws_vpc_security_group_ingress_rule" "eks_dns_tcp" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow DNS TCP"

  cidr_ipv4 = var.vpc_cidr

  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "eks_all_outbound" {
  security_group_id = aws_security_group.eks_node.id

  description = "Allow outbound traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


# =========================================================
# RDS SECURITY GROUP
# =========================================================

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
    }
  )
}


resource "aws_vpc_security_group_ingress_rule" "rds_mysql_from_eks" {
  security_group_id = aws_security_group.rds.id

  description = "Allow MySQL traffic from EKS nodes"

  referenced_security_group_id = aws_security_group.eks_node.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "rds_all_outbound" {
  security_group_id = aws_security_group.rds.id

  description = "Allow outbound traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_app_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  private_db_subnet_cidrs = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]

  enable_flow_logs = true

  tags = {
    Project   = "ecommerce"
    ManagedBy = "Terraform"
  }
}
module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

  tags = {
    Project   = "ecommerce"
    ManagedBy = "Terraform"
  }
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  tags = {
    Project   = "ecommerce"
    ManagedBy = "Terraform"
  }
}

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  cluster_name       = "${var.project_name}-${var.environment}-eks"
  kubernetes_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_app_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn

  node_role_arn = module.iam.node_role_arn

  node_security_group_id = module.security_groups.eks_node_security_group_id
  ebs_csi_role_arn       = module.iam.ebs_csi_role_arn
  node_instance_types = [
    "c7i-flex.large"
  ]

  node_capacity_type = "ON_DEMAND"

  node_min_size     = 2
  node_max_size     = 4
  node_desired_size = 2

  disk_size = 30

  enable_cluster_logs = true

  tags = {
    Project     = "ecommerce"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}



module "alb_controller" {
  source = "../../modules/alb-controller"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = module.eks.cluster_name

  vpc_id = module.vpc.vpc_id

  alb_controller_role_arn = module.iam.alb_controller_role_arn

  chart_version = "1.14.0"

  tags = {
    Project     = "ecommerce"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    module.eks,
    module.iam
  ]
}
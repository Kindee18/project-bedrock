module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32" # Adjusted to a realistic recent version, will use 1.34 if possible

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    main = {
      min_size     = 3
      max_size     = 4
      desired_size = 3

      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"
    }
  }

  # Control Plane Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Access Entry for IAM user mapping
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    developer = {
      kubernetes_groups = ["viewers"]
      principal_arn     = aws_iam_user.bedrock_dev_view.arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Project = "Bedrock"
  }
}

# CloudWatch Observability Add-on
# NOTE: This addon can take 15-20 minutes to become active
# If deployment times out, you can apply it separately after cluster is ready
# Uncomment after initial cluster deployment succeeds

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"

  tags = {
    Project = "Bedrock"
  }
}

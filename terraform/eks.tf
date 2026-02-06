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
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"]
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
        viewer = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["retail-app"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Project = "Bedrock"
  }
}

# Add-on for Observability
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"
}

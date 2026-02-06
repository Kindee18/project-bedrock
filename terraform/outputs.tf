output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "The name of the S3 bucket for assets"
  value       = aws_s3_bucket.assets.id
}

# Credentials for bedrock-dev-view (Required for submission)
output "dev_access_key_id" {
  description = "Access Key ID for bedrock-dev-view"
  value       = aws_iam_access_key.bedrock_dev_view.id
  sensitive   = true
}

output "dev_secret_access_key" {
  description = "Secret Access Key for bedrock-dev-view"
  value       = aws_iam_access_key.bedrock_dev_view.secret
  sensitive   = true
}

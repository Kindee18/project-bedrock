variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "project-bedrock-vpc"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "student_id" {
  description = "Student ID for resource naming"
  type        = string
  default     = "alt-soe-025-1148"
}

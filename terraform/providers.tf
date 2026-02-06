terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = "Bedrock"
    }
  }
}

# The kubernetes and helm providers will be configured after the EKS cluster is created.
# This usually requires a data source for the cluster credentials.

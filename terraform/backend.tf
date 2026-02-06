terraform {
  backend "s3" {
    bucket         = "project-bedrock-terraform-state" # Replace with your state bucket
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock" # Replace with your lock table
    encrypt        = true
  }
}

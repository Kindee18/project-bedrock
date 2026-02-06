terraform {
  backend "s3" {
    bucket         = "bedrock-tfstate-alt-soe-025-1148"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-terraform-lock"
    encrypt        = true
  }
}

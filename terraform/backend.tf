# Remote State Backend Configuration
# NOTE: Before enabling this backend:
# 1. Create an S3 bucket for state storage
# 2. Create a DynamoDB table for state locking
# 3. Update the bucket and table names below
# 4. Uncomment this block
# 5. Run: terraform init -migrate-state

# terraform {
#   backend "s3" {
#     bucket         = "project-bedrock-terraform-state"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt        = true
#   }
# }

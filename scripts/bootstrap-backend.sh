#!/bin/bash
# Bootstrap script to create Terraform backend resources
# This must be run BEFORE terraform init

set -e

BUCKET_NAME="bedrock-tfstate-alt-soe-025-1148"
DYNAMODB_TABLE="bedrock-terraform-lock"
REGION="us-east-1"

echo "Creating Terraform backend resources..."

# Create S3 bucket for state
echo "Creating S3 bucket: $BUCKET_NAME"
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  2>/dev/null || echo "Bucket already exists"

# Enable versioning
echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Enable encryption
echo "Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
echo "Blocking public access on S3 bucket..."
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# Create DynamoDB table for state locking
echo "Creating DynamoDB table: $DYNAMODB_TABLE"
aws dynamodb create-table \
  --table-name "$DYNAMODB_TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION" \
  2>/dev/null || echo "Table already exists"

echo "✅ Backend resources created successfully!"
echo "You can now run: cd terraform && terraform init"

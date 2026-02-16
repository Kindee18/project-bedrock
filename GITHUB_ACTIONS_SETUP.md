# GitHub Actions Setup Guide

## Step 1: Bootstrap the Terraform Backend

**The S3 backend must be created BEFORE running Terraform.** Run this locally first:

```bash
# Ensure AWS CLI is configured with your credentials
aws configure

# Run the bootstrap script to create S3 bucket and DynamoDB table
./scripts/bootstrap-backend.sh
```

This creates:
- S3 bucket: `bedrock-tfstate-alt-soe-025-1148` (with versioning and encryption)
- DynamoDB table: `bedrock-terraform-lock` (for state locking)

## Step 2: Add GitHub Secrets

Navigate to: `https://github.com/Kindee18/project-bedrock/settings/secrets/actions`

Click **"New repository secret"** and add:

| Secret Name | Value |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key |

> [!IMPORTANT]
> These credentials should have permissions to create VPC, EKS, IAM, S3, and Lambda resources.

## Step 3: Test the Workflow

After completing Steps 1 and 2:
1. Make a small change to any file (e.g., update README.md)
2. Commit and push to the `main` branch
3. Go to the **Actions** tab to see the workflow run successfully

## Workflow Behavior

- **Pull Request**: Runs `terraform plan` to show proposed changes
- **Push to main**: Runs `terraform apply` to deploy infrastructure

## Cleanup

To avoid ongoing costs, destroy infrastructure after grading:
```bash
cd terraform
terraform destroy
```

To delete backend resources:
```bash
aws s3 rb s3://bedrock-tfstate-alt-soe-025-1148 --force
aws dynamodb delete-table --table-name bedrock-terraform-lock --region us-east-1
```

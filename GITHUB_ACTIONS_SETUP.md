# GitHub Actions Setup Guide

## Required Secrets

Before the CI/CD workflow can run successfully, you must configure the following secrets in your GitHub repository:

### 1. Navigate to Repository Settings
Go to: `https://github.com/Kindee18/project-bedrock/settings/secrets/actions`

### 2. Add AWS Credentials

Click **"New repository secret"** and add:

| Secret Name | Value |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key |

> [!IMPORTANT]
> These credentials should have sufficient permissions to create VPC, EKS, IAM, S3, and Lambda resources.

### 3. Test the Workflow

After adding secrets:
1. Make a small change to any file (e.g., update README.md)
2. Commit and push to the `main` branch
3. Go to the **Actions** tab to see the workflow run

## Backend State Management

The remote backend (S3 + DynamoDB) is currently **disabled** to allow local testing.

To enable remote state:
1. Create an S3 bucket: `project-bedrock-terraform-state-[unique-suffix]`
2. Create a DynamoDB table: `terraform-state-lock` with primary key `LockID` (String)
3. Update `terraform/backend.tf` with your bucket name
4. Uncomment the backend configuration
5. Run `terraform init -migrate-state`

## Workflow Behavior

- **Pull Request**: Runs `terraform plan` to show proposed changes
- **Push to main**: Runs `terraform apply` to deploy infrastructure

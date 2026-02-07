#!/bin/bash

# This script deploys the AWS Retail Store Sample App to the EKS cluster.

# 1. Login to ECR Public Gallery (optional, public images don't require auth usually)
# aws ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin public.ecr.aws

# 2. Deploy the application to the retail-app namespace using OCI chart
# The chart will deploy microservices with in-cluster dependencies by default.
helm install my-retail-app oci://public.ecr.aws/aws-containers/retail-store-sample-chart \
  --namespace retail-app \
  --create-namespace \
  --wait

echo "Retail Store Application deployed successfully!"

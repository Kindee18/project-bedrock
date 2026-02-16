#!/bin/bash

# This script deploys the AWS Retail Store Sample App to the EKS cluster.

# 1. Login to ECR Public Gallery (optional, public images don't require auth usually)
# aws ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin public.ecr.aws

# 2. Deploy the application to the retail-app namespace using OCI chart
# The chart will deploy microservices with in-cluster dependencies by default.
# Deploy/Upgrade using RDS and Ingress values
# 1. Get RDS Endpoints from Terraform
echo "Retrieving RDS endpoints from Terraform..."
cd terraform
# Extract value and remove port :3306 or :5432 if needed (Helm might expect host only or host:port)
# Catalog expects "endpoint" string. Usually host:port? Or just host?
# values-all.yaml said: endpoint: "" for catalog.
# orders said: endpoint: { host: "", port: "" }.
# So for orders I need host. For catalog I need ??
# MySQL JDBC usually needs host.
# Let's clean the output.
export CATALOG_ENDPOINT=$(terraform output -raw catalog_db_endpoint | cut -d':' -f1)
export ORDERS_ENDPOINT=$(terraform output -raw orders_db_endpoint | cut -d':' -f1)
cd ..

echo "Catalog Endpoint: $CATALOG_ENDPOINT"
echo "Orders Endpoint: $ORDERS_ENDPOINT"

# 2. Generate values file
echo "Generating values-rds.yaml..."
envsubst < k8s/values-rds.template.yaml > k8s/values-rds.yaml

# 3. Upgrade Release
echo "Upgrading Helm release with RDS and Ingress..."
# Use absolute path for helm since it's in ~/bin
~/bin/helm upgrade --install my-retail-app oci://public.ecr.aws/aws-containers/retail-store-sample-chart \
  --namespace retail-app \
  --create-namespace \
  --values k8s/values-rds.yaml \
  --wait

echo "Retail Store Application upgraded successfully!"

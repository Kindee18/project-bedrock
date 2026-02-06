#!/bin/bash

# This script deploys the AWS Retail Store Sample App to the EKS cluster.

# 1. Add and update the Helm repository
helm repo add retail-store https://aws-containers.github.io/retail-store-sample-app
helm repo update

# 2. Deploy the application to the retail-app namespace
# The chart will deploy microservices with in-cluster dependencies by default.
helm install my-retail-app retail-store/retail-store-sample-app \
  --namespace retail-app \
  --create-namespace \
  --wait

echo "Retail Store Application deployed successfully!"

# Project Bedrock - Submission Checklist

## 📝 Google Doc Content Template

### 1. Git Repository Link
```
https://github.com/Kindee18/project-bedrock
```
**Status:** Ensure repository is PUBLIC or access granted to grader

---

### 2. Architecture Diagram
Include the Mermaid diagram from README.md or create a visual diagram showing:
- VPC with public/private subnets across 2 AZs
- EKS Cluster with microservices (UI, Catalog, Cart, Checkout, Orders)
- RDS instances (MySQL for Catalog, PostgreSQL for Orders)
- S3 bucket → Lambda → CloudWatch flow
- ALB with TLS termination
- CI/CD pipeline (GitHub Actions → Terraform)

---

### 3. Deployment Guide

#### Infrastructure Deployment
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

#### Application Deployment
```bash
./scripts/helm-install.sh
```

#### CI/CD Pipeline
- **Trigger Plan:** Create a Pull Request to main branch
- **Trigger Apply:** Merge PR to main branch
- **Manual Trigger:** Go to Actions tab → Terraform workflow → Run workflow

---

### 4. Application Access URLs

**Standard HTTP Access:**
```
http://k8s-retailap-myretail-41b4c633b8-774591857.us-east-1.elb.amazonaws.com
```

**Secure HTTPS Access (with TLS):**
```
https://54-147-83-15.nip.io
```
*Note: Self-signed certificate - accept security warning in browser*

---

### 5. Grading Credentials (bedrock-dev-view)

- [ ] **Access Key ID:** `AKIAR2JFENPC...` (Get from `terraform output`)
- [ ] **Secret Access Key:** `3BSUQRNsG...` (Get from `terraform output`)

**Verification Commands:**
```bash
# Configure AWS CLI with these credentials
aws configure --profile bedrock-dev

# Test AWS Console ReadOnly access
aws eks describe-cluster --name project-bedrock-cluster --region us-east-1 --profile bedrock-dev

# Test Kubernetes RBAC (read-only)
aws eks update-kubeconfig --name project-bedrock-cluster --region us-east-1 --profile bedrock-dev
kubectl get pods -n retail-app  # ✅ Should work
kubectl delete pod <pod-name> -n retail-app  # ❌ Should fail (read-only)
```

---

### 6. Serverless Feature Test

**Upload test image to S3:**
```bash
# Create a test image
echo "test image content" > test-image.jpg

# Upload to S3 bucket
aws s3 cp test-image.jpg s3://bedrock-assets-alt-soe-025-1148/

# Check Lambda logs in CloudWatch
aws logs tail /aws/lambda/bedrock-asset-processor --follow
```

**Expected Output in CloudWatch:**
```
Image received: test-image.jpg
```

---

### 7. Grading Data File
✅ `grading.json` file is committed to repository root
- Location: `/grading.json`
- Generated via: `terraform output -json > grading.json`

---

## 📊 Requirements Compliance Matrix

| Category | Requirement | Status |
|----------|-------------|--------|
| **Standards** | Region: us-east-1 | ✅ |
| **Standards** | Cluster: project-bedrock-cluster | ✅ |
| **Standards** | VPC: project-bedrock-vpc | ✅ |
| **Standards** | Namespace: retail-app | ✅ |
| **Standards** | IAM User: bedrock-dev-view | ✅ |
| **Standards** | S3: bedrock-assets-alt-soe-025-1148 | ✅ |
| **Standards** | Lambda: bedrock-asset-processor | ✅ |
| **Standards** | Tagging: Project: Bedrock | ✅ |
| **Infrastructure** | VPC with 2+ AZs | ✅ |
| **Infrastructure** | EKS Cluster (>= 1.34.0) | ✅ |
| **Infrastructure** | Remote State (S3 + DynamoDB) | ✅ |
| **Application** | Retail Store in retail-app namespace | ✅ |
| **Application** | All pods healthy | ✅ |
| **Security** | Developer IAM with ReadOnly | ✅ |
| **Security** | Kubernetes RBAC (view role) | ✅ |
| **Observability** | Control Plane logs to CloudWatch | ✅ |
| **Observability** | Container logs to CloudWatch | ✅ |
| **Serverless** | S3 → Lambda trigger | ✅ |
| **Serverless** | Lambda logs to CloudWatch | ✅ |
| **CI/CD** | Plan on PR | ✅ |
| **CI/CD** | Apply on Merge | ✅ |
| **BONUS** | RDS MySQL (Catalog) | ✅ |
| **BONUS** | RDS PostgreSQL (Orders) | ✅ |
| **BONUS** | ALB Ingress Controller | ✅ |
| **BONUS** | TLS/HTTPS Termination | ✅ |

---

## 📤 Submission Steps

1. ✅ Ensure `grading.json` is in repository root
2. ✅ Make GitHub repository PUBLIC
3. ✅ Create Google Doc with all sections above
4. ✅ Share Google Doc with: **innocent@altschoolafrica.com** (Viewer access)
5. ✅ Double-check all URLs and credentials are correct
6. ✅ Test developer credentials before submitting

---

## 🎯 Key Highlights for Grader

- **100% Core Requirements:** All mandatory features implemented
- **100% Bonus Objectives:** RDS persistence + ALB with TLS
- **Production-Ready:** Automated CI/CD, secure access, comprehensive logging
- **Well-Documented:** Complete README with architecture diagram and verification steps
- **Clean Code:** Modular Terraform, proper tagging, least-privilege IAM

---

**Project Completion Date:** 2026-02-08  
**Student:** Kindson  
**Repository:** https://github.com/Kindee18/project-bedrock

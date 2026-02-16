# Project Bedrock Architecture

High-level architecture of the Retail Store infrastructure on AWS EKS.

## System Diagram

```mermaid
graph TD
    subgraph "AWS Cloud (us-east-1)"
        subgraph "VPC: project-bedrock-vpc"
            ALB[Application Load Balancer]
            
            subgraph "EKS Cluster: project-bedrock-cluster"
                subgraph "Namespace: retail-app"
                    Ingress[ALB Ingress]
                    UI[UI Service]
                    Catalog[Catalog Service]
                    Orders[Orders Service]
                    Carts[Carts Service]
                    Checkout[Checkout Service]
                    Assets[Assets Service]
                end
            end
            
            subgraph "Data Layer"
                RDS_MySQL[(RDS MySQL\nCatalog DB)]
                RDS_PG[(RDS PostgreSQL\nOrders DB)]
                Redis[(ElastiCache Redis\nCheckout DB)]
            end
        end
        
        subgraph "Serverless Operations"
            S3_Assets[S3 Bucket\nbedrock-assets-...]
            Lambda[Lambda Function\nbedrock-asset-processor]
        end
        
        CW[CloudWatch Logs]
    end
    
    User[User] -->|HTTPS| ALB
    ALB --> Ingress
    Ingress --> UI
    
    UI --> Catalog
    UI --> Orders
    UI --> Carts
    UI --> Checkout
    UI --> Assets
    
    Catalog --> RDS_MySQL
    Orders --> RDS_PG
    Checkout --> Redis
    
    Assets -->|Upload| S3_Assets
    S3_Assets -->|Event Trigger| Lambda
    Lambda -->|Log| CW
    
    EKS_CP[EKS Control Plane] -->|Audit/API Logs| CW
    Pods[Application Pods] -->|Container Logs| CW
```

## Developer Access

*   **IAM User**: `bedrock-dev-view`
*   **Console Access**: ReadOnlyAccess
*   **Cluster Access**: `view` ClusterRole (mapped via Access Entry)

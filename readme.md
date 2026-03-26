# End-to-End Software Application Deployment (AWS)

## Project Overview

This project demonstrates a complete end-to-end cycle of deploying a software application onto AWS cloud infrastructure. It follows an iterative development cycle, with each iteration introducing further enhancements. By the final stage, the architecture evolves into a resilient, secure, and scalable cloud solution ready for production.

Throughout each development cycle, I outline the core features of every tool and explain why it is being used. To help build a clearer understanding, I highlight how each cycle differs, how the components align with one another, and how the entire process flows seamlessly—almost like running water—towards the final production-ready system.

---

## Tools

| Tool / Service | Purpose & Utilisation |
|----------------|------------------------|
| **Terraform** | Automates the provisioning and management of AWS infrastructure in a consistent and repeatable manner. |
| **Docker** | Containerises the application to ensure consistent execution across different environments. |
| **ALB (Internet Facing) – AWS** | Acts as the main entry point for web traffic and routes incoming requests to ECS tasks. |
| **ECS (Fargate) – AWS** | Runs containerised applications without the need to manage underlying servers. |
| **Amazon RDS (PostgreSQL / MySQL) – AWS** | Provides a managed relational database hosted securely within private subnets. |
| **GitHub Actions (CI/CD)** | Automates the build, testing, and deployment process for the application. |
| **CloudWatch – AWS** | Monitors application health, performance, logs, and ECS task activity. |
| **VPC – AWS** | Defines the network structure, including public and private subnets, routing, and security. |

---

## Iterative Cycle  
### **Grouped Object: Development (DEV)**

The development cycle forms the foundation of the architecture. It introduces the essential components that act as the exoskeleton of the cloud environment. This groundwork ensures that subsequent cycles can build upon a stable, secure, and scalable base.

The architecture for this cycle is shown below.

---

## **VPC: `VPC-MAIN`**

### Components

| Component | Description |
|----------|-------------|
| **Private Subnets** | Host ECS Fargate tasks and the Amazon RDS database (PostgreSQL/MySQL). |
| **Public Subnets** | Host the ALB, optional ALB-B, and the NAT Gateway. |
| **Route Tables** | Provide public and private routing for correct traffic flow. |
| **Internet Gateway** | Enables public internet access for resources in public subnets. |
| **NAT Gateway** | Allows private subnets to access the internet in a secure manner. |

---

## Security Groups

Security groups define ingress and egress rules for each component, controlling communication between the ALB, ECS tasks, and the RDS database.

### Security Group Rules

| Component | Ingress | Egress | Port(s) |
|----------|---------|--------|---------|
| **ALB (Internet Facing)** | HTTP/HTTPS from the public internet | Forwards traffic to ECS tasks | 80, 443 |
| **ECS Tasks (Fargate)** | Traffic only from the ALB | Outbound access to RDS and via NAT | Application port (e.g., 3000) |
| **Amazon RDS (PostgreSQL/MySQL)** | Only from ECS tasks | — | 5432 (PostgreSQL) / 3306 (MySQL) |

---

## Subnets (6)

| Availability Zone | Subnet Name       | Type / Purpose | Notes                         |
|------------------|-------------------|----------------|-------------------------------|
| eu-west-2a       | alb-subnet        | Public         | For ALB in AZ-a               |
| eu-west-2a       | public-natgateway | Public         | NAT Gateway resides here      |
| eu-west-2a       | private-rds-a     | Private        | RDS subnet (AZ-a)             |
| eu-west-2a       | private-ecs       | Private        | ECS tasks run here            |
| eu-west-2b       | alb-subnet-b      | Public         | For ALB in AZ-b               |
| eu-west-2b       | private-rds-b     | Private        | RDS subnet (AZ-b)             |

---

## Network Connections

| Name  | Type             | Notes                                      |
|-------|------------------|--------------------------------------------|
| main  | Internet Gateway | Provides internet access to public subnets |
| gw NAT| NAT Gateway      | Allows private subnets outbound internet access via NAT |

---

# IAM Roles for ECS Task Execution

## IAM Roles & Policies Table

| IAM Role Name                    | Policy Attached                                   | Purpose / Permissions Provided                                           |
|----------------------------------|----------------------------------------------------|---------------------------------------------------------------------------|
| **ecsTaskExecutionRole**         | `AmazonECSTaskExecutionRolePolicy`                 | Allows ECS tasks to pull container images from **ECR** and access AWS Secrets Manager & Parameter Store. |
|                                  | `CloudWatchLogsFullAccess` (or a custom minimal policy) | Enables ECS tasks to write logs to CloudWatch Logs.                       |
| **ecsTaskRole** *(optional)*     | Custom policies                                     | Required only if the application itself needs access to AWS services such as DynamoDB or S3. |

---

# IAM Roles

| IAM Role Name            | Policy Name                                   | Purpose                                      |
|--------------------------|-----------------------------------------------|----------------------------------------------|
| ecsTaskExecutionRole     | AmazonECSTaskExecutionRolePolicy              | Allows ECS to pull images from ECR           |
| ecsTaskExecutionRole     | CloudWatchLogsFullAccess (or minimal CW policy) | Allows ECS to send logs to CloudWatch Logs    |

---

# Compute

## EC2 Instance – ALB
- The Application Load Balancer is **internet-facing**.
- A target group is configured for **two ECS tasks** running in Fargate.
- ALB listeners:
  - **HTTP (port 80)** used for initial testing.
  - **HTTPS (port 443)** serves as the primary production entry point.

## ECS (Fargate)
- **Cluster:** `CLUSTER APP`
- ECS **Service** attached to the ALB for handling incoming traffic.
- ECS **Task Definition** based on the application's Docker configuration:
  - Container port mappings configured.
  - Environment variables set for hostname, RDS connection details, and application configuration.
- ECS **Service is configured to run with two desired tasks**, providing high availability and resilience.
- Tasks are spread across availability zones where possible for greater redundancy.

## CloudWatch
- Integrated with ECS tasks to provide:
  - Performance metrics  
  - Health monitoring  
  - Application and container logs  
  - Error tracking for troubleshooting  

## Amazon RDS (PostgreSQL / MySQL)
- The RDS instance is deployed in **private subnets** within the VPC.
- Isolated from the public internet to ensure improved security.
- Acts as the primary database layer for the application architecture.

Second cycle (staging) focuses on adding addtional components and en ehnacing existing ones in order to evolve the architecture into more scalable, secure infrastructure that aligns and mirrors production standards. 

This cycle introduces secure TLS communication, DNS management via Cloudflare, IAM hardening, microservice expansion, ALB path‑based routing, and improved observability. These enhancements ensure the system evolves into a resilient, secure, and scalable cloud platform ready for production.

Additional components

Microservices – URL Shortener
A new microservice was introduced to demonstrate horizontal scaling, service separation, and multi‑service orchestration within the cloud architecture.

URL Shortener Service Overview

urls shortner outline table

image (source code): source code written in javascript, node,js - source is not mine. however, adjusted inorder to retrieve mapping of uiid in s3 bucket, also implemented the correct environment needed to run and created a suitable docker file to containerise the application.
s3 bucket (website-uiid): user requires to store website uiid for node.js as mapping for url shortner, ideally the website uiid is used as mapping protocol in order to map specific website sessions according to your mappings. 
component: deployed on ecs Fargate, task definition set to resemble the images envicronment accuratley. ecs has a specific role tasks been adding inorder for it to access the s3 bucket to read the uiid and apply it.

Component	Description
ECS Fargate Service	Runs independently within private subnets as a separate microservice.
Task Definition	Defined specifically for the URL Shortener service.
IAM Role	Grants only the permissions required by this microservice.
CloudWatch Logs	Enabled for observability, debugging, and performance monitoring.
This addition demonstrates how the architecture can expand to support multiple independent services running concurrently.


enhancing existing components 

Staging Enhancements
1. Secure TLS and DNS Management
To align the environment with production‑grade security, TLS encryption and domain‑based routing were introduced.

TLS & DNS Enhancements
Component	Description
ACM Certificate	Issued to enable secure TLS communication across the environment.
ALB Listener Update	Upgraded from HTTP (port 80) to HTTPS (port 443) for encrypted traffic.
Cloudflare DNS	Configured with a CNAME pointing to the ALbalancing domain‑based access.
These changes ensure encrypted traffic, improved trust, and a production‑aligned entry point.

2. IAM – Least Privilege Access
IAM roles and permissions were refined to enforce stricter access boundaries and ensure that staging reflects real‑world security practices.

IAM Role Adjustments
Role	Permissions	Purpose
Developer IAM Role	Read‑only access to the database	Prevents write/delete operations while allowing safe inspection of data.
Staging‑Specific Policies	Restricted permissions tailored to staging	Ensures tighter access control and compliance with least‑privilege principles.
This ensures that only the minimum required permissions are granted, reducing risk and improving security posture.

ALB Path‑Based Routing
To support multiple microservices behind a single ALB, path‑based routing was introduced.

Routing Enhancements
Feature	Description
New Target Group	Created specifically for the URL Shortener ECS service.
Path‑Based Rule	Routes /shorten/* traffic to the URL Shortener service.
Health Checks	Monitor the availability and health of the URL Shortener tasks.
This introduces a scalable microservice routing pattern and ensures reliable traffic distribution across services.

CI/CD Pipeline Enhancements
The CI/CD workflow was updated to support multi‑service deployments and staging‑specific requirements.

CI/CD Improvements
Stage	Description
Build	Builds Docker images for both the main application and the URL Shortener microservice.
Push	Pushes images to their respective ECR repositories.
Deploy	Updates ECS services in the staging environment with new task definitions.
This ensures deployments are automated, consistent, and aligned with production workflows.

demo 




The staging iteration transforms the foundational DEV architecture into a production‑aligned environment by introducing secure communication, DNS management, IAM hardening, microservice expansion, and advanced routing. These enhancements ensure the system is robust, secure, and operationally ready for the final production rollout.
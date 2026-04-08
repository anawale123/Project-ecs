# Project Overview

## AWS Cloud Infrastructure Migration — ECS Fargate, RDS, S3, Terraform

End-to-end migration of a self-hosted web analytics platform onto AWS cloud infrastructure. The project covers the full delivery cycle from running the application locally with Docker Compose through to a production-grade deployment on AWS ECS Fargate, with infrastructure provisioned as code using Terraform and three CI/CD pipelines automating builds, infrastructure changes, and deployments.

---

## Deliverables

- Fully deployed application running on AWS ECS Fargate behind an internet facing ALB  
- VPC built from scratch across public and private subnets with all networking configured  
- Terraform modules written from scratch and structured for reusability across environments  
- CI/CD pipeline configured to build, push, and deploy Docker images to ECS automatically  
- Blue/green deployment strategy via CodeDeploy with zero downtime rollouts  
- RDS PostgreSQL provisioned in private subnets with automated backups and deletion protection  
- IAM least privilege applied across all roles, task definitions, and policies  
- Secrets and database credentials managed via AWS Secrets Manager with KMS encryption  
- CloudWatch dashboards and alarms configured across ECS, ALB, and RDS  
- WAF attached to the ALB with AWS managed rule sets for security filtering  
- Full documentation covering architecture, infrastructure, and deployment process  

---

## Service

### Umami — Web Analytics

Umami is an open-source, self-hosted web analytics application. It collects and displays website traffic data, providing an alternative to third-party analytics platforms that can be fully owned and operated on private infrastructure.

Source: https://github.com/umami-software/umami

#### Resource Details

| Resource        | Details                                                                 |
|----------------|-------------------------------------------------------------------------|
| ECS Service    | Fargate service running the Umami application on port 3000              |
| ECS Task       | credentials injected from Secrets Manager at startup                    |
| RDS PostgreSQL | Dedicated PostgreSQL 15 instance in private subnets stores all analytics data |

---

## Documentation

Extra two documents are accompanied with this project, covering the full delivery process and the infrastructure in detail.

| Document               | Covers                                                                 |
|------------------------|------------------------------------------------------------------------|
| Deployment Lifecycle   | Step-by-step record of how the platform was delivered across four phases, local testing, dev, staging, and production including the CI/CD pipelines and vulnerability findings from image scanning |
| Architecture README    | Full infrastructure reference networking, compute, database, autoscaling, blue/green deployment, observability, security, cost decisions, and Terraform module structure |

---


## Demo

Umami application running on  private ECS Fargate subnet behind an internet-facing ALB.

![Application Running](assets/application-running.gif)

---

## CI/CD Pipeline

### Container Build & Push

Created a workflow that builds the Docker image, scans for vulnerabilities and pushes to ECR.

![CI Workflow](assets/ci_yml.png)

### Infrastructure as Code

Infrastructure pipeline using `iac.yml` to provision all AWS infrastructure via Terraform.

![IaC Workflow](assets/iac_yml.png)

### Code Deployment Trigger

Pipeline to trigger CodeDeploy for blue/green deployments.

![CodeDeploy Workflow](assets/cd_yml.png)

---

## Zero-Downtime Deployment

Successfully executed zero-downtime deployment via blue/green deployment on AWS CodeDeploy.

![CodeDeploy Live](assets/cd.png)

---

## Security

All credentials are stored in AWS Secrets Manager and AWS configuration is done through AWS OIDC. No hard coded credentials or key phreaes.



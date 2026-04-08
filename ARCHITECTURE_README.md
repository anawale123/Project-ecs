# Architecture README
## AWS Cloud Infrastructure — ECS Fargate, RDS, ALB, CodeDeploy, WAF, CloudWatch, Terraform

A full-stack monolithic web application built with Next.js for the frontend, running on the Node.js runtime, using Express as the backend server and Prisma as the ORM for PostgreSQL. The application is containerised locally with Docker Compose and deployed onto AWS ECS Fargate, with the VPC built from scratch using Terraform. A CI/CD pipeline handles building and pushing Docker images to ECR and triggering deployments to ECS.

The infrastructure is designed to be production-ready with high availability, strong security practices, and full observability across all components.
## Architecture Diagram



![Architecture Diagram](assets/ecs.drawio.png)


---

## Networking

### Public Subnets

| Component    | AZ          | CIDR          | Route Table    | Gateway |
|-------------|------------|--------------|---------------|--------|
| ALB A        | eu-west-2b  | 10.0.2.0/24   | public_rt      | IGW     |
| ALB B        | eu-west-2c  | 10.0.3.0/24   | public_rt      | IGW     |
| NAT Gateway  | eu-west-2c  | 10.0.8.0/24   | public_rt_nat  | NAT GW  |

### Private Subnets

| Component | AZ          | CIDR           | Route Table |
|----------|------------|---------------|------------|
| ECS       | eu-west-2c  | 10.0.4.0/24    | private_rt  |
| RDS A     | eu-west-2b  | 10.0.7.0/24    | private_rt  |
| RDS B     | eu-west-2b  | 10.0.11.0/24   | private_rt  |

### Security Groups

| Component | Inbound Rules                                  | Outbound    |
|----------|------------------------------------------------|------------|
| ALB       | HTTPS 443 from anywhere (0.0.0.0/0)            | All traffic |
| ECS       | Ports 80, 443, 3000, 3001 from ALB SG only     | All traffic |
| RDS       | Port 5432 from ECS SG only                     | All traffic |

---

## Compute

### ECS Fargate Services

| Service        | Port | CPU | Memory  | Desired Count |
|---------------|------|-----|--------|--------------|
| Umami          | 3000 | 256 | 512 MB  | 2             |


### Load Balancing — ALB Listener Rules

| Rule | Path Pattern | Target Group      |
|-----|-------------|------------------|
| A    | /*           | UMAMI, TG         |
| B    | /health      | UMAMU,TG          |

### Target Groups

| Target Group    | Port | Protocol | Health Check | Valid Codes |
|----------------|------|---------|-------------|------------|
| Umami (main)    | 3000 | HTTP     | /*           | 200–399     |
| Umami (health)  | 3000 | HTTP     | /health      | 200–399     |
| Blue            | 3000 | HTTP     | Default      | —           |
| Green           | 3000 | HTTP     | Default      | —           |

---

## Database

### RDS PostgreSQL

| Configuration       | Value                          |
|--------------------|-------------------------------|
| Engine              | PostgreSQL 15.13               |
| Instance Class      | db.t3.micro                    |
| Storage             | 20 GB gp2                      |
| Network             | Private subnets only           |
| Public Access       | Disabled                       |
| Deletion Protection | Enabled                        |
| Backup Retention    | 7 days                         |
| Maintenance Window  | Friday 09:00 – 09:30 UTC       |
| CloudWatch Exports  | postgresql, upgrade            |

---

## CI/CD Deployment

### CodeDeploy Blue/Green

Blue is the live version; Green is the incoming version. Traffic shifts only after Green passes all health checks. The old task set is terminated after a 5-minute stabilisation window.

| Setting                | Value                    |
|-----------------------|-------------------------|
| Deployment Type        | BLUE_GREEN               |
| Deployment Option      | WITH_TRAFFIC_CONTROL     |
| Termination Action     | Terminate old task set   |
| Termination Wait Time  | 5 minutes                |
| Blue Target Group      | Blue TG                  |
| Green Target Group     | Green TG                 |

---

## Autoscaling

| Component         | Configuration                                          |
|------------------|------------------------------------------------------|
| Scaling Target    | Min 2 tasks — Max 6 tasks                             |
| CPU Scale Out     | Target tracking at 60% · Cooldown: 30s out / 120s in |
| Memory Scale Out  | Target tracking at 70%                                |
| CPU Scale In      | Step scaling below threshold · Cooldown: 180s         |
| CPU Low Alarm     | Triggered below 30% across 2 consecutive periods      |

---

## Observability

### cloudwatch
## cloudwatch dashboard 


## CloudWatch Dashboard
## CloudWatch Dashboard

| Metric | Stat | Period |
|--------|------|--------|
| ALB Target Response Time | Average | 60s |
| ALB 4xx & 5xx Errors | Sum | 60s |
| ALB Request Count | Sum | 60s |
| ECS CPU Utilization | Average | 60s |
| ECS Memory Utilization | Average | 60s |
| ECS Running Task Count | Average | 60s |
| WAF Blocked Requests | Sum | 300s |
---

## Security

| Component  | Configuration                                              |
|-----------|----------------------------------------------------------|
| WAF        | AWS Managed Rules attached to ALB                         |
| IAM        | Least-privilege roles across all services                 |
| Secrets    | AWS Secrets Manager with KMS encryption                   |
| Network    | ECS and RDS in private subnets — no public inbound        |
| SSL / TLS  | HTTPS via ACM — TLS terminated at ALB                     |

---

## Cost Optimisation

| Component   | Decision              | Reason                                      |
|------------|----------------------|--------------------------------------------|
| ECS         | Serverless Fargate    | No EC2 maintenance — pay per use            |
| RDS         | db.t3.micro           | Right-sized for current workload            |
| Autoscaling | 2 to 6 tasks          | Scales only under genuine demand            |
| NAT Gateway | Single NAT            | Eliminates cross-AZ duplication cost        |
| CloudWatch  | Targeted alarms only  | Reduces unnecessary log ingestion cost      |
| Backups     | 7-day retention       | Balanced recovery window vs storage spend   |
| WAF         | Managed rule sets     | No custom rule authoring overhead           |
| S3          | Limited versioning    | Controls storage growth overhead            |

---

## Terraform Structure

### Directory Layout

```
~/project-ecs/terraform/infra/
~/project-ecs/terraform/infra/envs/dev/
~/project-ecs/terraform/infra/envs/staging/
~/project-ecs/terraform/infra/envs/prod/
```

### Modules

| Module             | Purpose                                                                    |
|-------------------|---------------------------------------------------------------------------|
| alb                | Application Load Balancer, listeners, target groups, and listener rules    |
| auto_scaling       | ECS autoscaling policies and CloudWatch scale-in/out alarms                |
| cloudwatch         | Dashboard, log groups, and alarms across ECS, ALB, and RDS                 |
| code_deployment    | CodeDeploy application and blue/green deployment group configuration        |
| ecs                | ECS cluster, Umami service, and task definition                            |
| iam                | Task execution role, task role, CodeDeploy role, and all associated policies|
| networking         | VPC, subnets, route tables, security groups, NAT Gateway, and Internet Gateway |
| rds                | RDS PostgreSQL instance, subnet group, parameter group, and snapshot        |
| waf                | Web ACL, managed rule sets, and ALB association                             |

Each module is self-contained and follows the DRY principle — keeping the infrastructure consistent and organised, making it straightforward to promote changes across environments.

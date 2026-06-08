# Architecture README
## AWS Cloud Infrastructure — ECS Fargate, RDS, ALB, CodeDeploy, WAF, CloudWatch, Terraform

## Umami Application Stack

- **Frontend:** Next.js
- **Runtime:** Node.js, Express
- **Database:** PostgreSQL, Prisma ORM

The application is containerised locally with Docker Compose and deployed onto AWS ECS Fargate, with the VPC built from scratch using Terraform. A CI/CD pipeline handles building and pushing Docker images to ECR and triggering deployments to ECS.
## Architecture Diagram

visual representation of the architecture deployed, showcasing dev pipelines, user interactions and components built and provision on terraform 

[View Architecture Diagram](architecture.drawio)


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
| A    | /api/heartbeat | Blue, TG        |


### Target Groups

| Target Group    | Port | Protocol | Health Check | Valid Codes |
|----------------|------|---------|-------------|------------|
| blue           | 3000 | HTTP     | /api/heartbeat | 200–399     |
| Green           | 3000 | HTTP     |/api/heartbeat  |  200–399  |

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

## Observability

### Cloudwatch Dashboard

| Metric | Stat | Period |
|--------|------|--------|
| ALB Target Response Time | Average | 60s |
| ALB 4xx & 5xx Errors | Sum | 60s |
| ALB Request Count | Sum | 60s |
| ECS CPU Utilization | Average | 60s |
| ECS Memory Utilization | Average | 60s |
| ECS Running Task Count | Average | 60s |
| WAF Blocked Requests | Sum | 300s |

### CloudWatch Alarms

| Component | Alarm Trigger |
|----------|----------------|
| **ECS Healthy Hosts** | Target group drops below 1 healthy task |
| **ECS CPU** | CPU exceeds 80% over a short evaluation period |
| **ECS Memory** | Memory exceeds 80% over two evaluation periods |
| **ALB 5xx Errors** | Target 5xx responses exceed the defined threshold |
| **ALB Latency** | Response time exceeds 1 second over multiple periods |
| **RDS CPU High** | CPU remains above 80% over multiple periods |



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
| NAT Gateway | Single NAT            | Eliminates cross-AZ duplication cost        |
| CloudWatch  | Targeted alarms only  | Reduces unnecessary log ingestion cost      |
| Backups     | 7-day retention       | Balanced recovery window vs storage spend   |
| WAF         | Managed rule sets     | No custom rule authoring overhead           |


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
| cloudwatch         | Dashboard, log groups, and alarms across ECS, ALB, and RDS                 |
| code_deployment    | CodeDeploy application and blue/green deployment group configuration        |
| ecs                | ECS cluster, Umami service, and task definition                            |
| iam                | Task execution role, task role, CodeDeploy role, and all associated policies|
| networking         | VPC, subnets, route tables, security groups, NAT Gateway, and Internet Gateway |
| rds                | RDS PostgreSQL instance, subnet group, parameter group, and snapshot        |
| waf                | Web ACL, managed rule sets, and ALB association                             |

Each module is self-contained and follows the DRY principle keeping the infrastructure consistent and organised, making it straightforward to promote changes across environments.

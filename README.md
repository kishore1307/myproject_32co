# DevOps Home Assessment

A complete DevOps implementation featuring Infrastructure as Code, CI/CD pipeline, secrets management, and monitoring for a scalable web application.

## Architecture Overview

This solution implements:
- **AWS VPC** with public/private subnets across multiple AZs
- **Application Load Balancer** with auto-scaling EC2 instances
- **RDS PostgreSQL** database with encryption
- **S3** for static asset storage
- **AWS Secrets Manager** for secure credential management
- **CloudWatch** for monitoring and alerting
- **GitHub Actions** for CI/CD automation

## Quick Start

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Python 3.9+
- Docker (for local development)

### Deployment Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd devops-assessment
   ```

2. **Configure variables**
   ```bash
   # Update terraform/terraform.tfvars
   alert_email = "your-email@example.com"
   aws_region  = "us-east-1"
   ```

3. **Deploy infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

4. **Setup CI/CD**
   - Configure GitHub secrets:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
   - Push to main branch to trigger deployment

## Tools and Technologies Used

- **Infrastructure**: AWS, Terraform
- **Application**: Python Flask, PostgreSQL
- **CI/CD**: GitHub Actions
- **Monitoring**: CloudWatch, SNS
- **Security**: IAM, Security Groups, Secrets Manager
- **Containerization**: Docker
- **Testing**: pytest

## Security Features

- VPC with private subnets for database and compute
- Security groups with least privilege access
- Encrypted RDS database
- AWS Secrets Manager for credential management
- IAM roles with minimal required permissions
- HTTPS termination at load balancer (when SSL configured)

## Monitoring and Alerting

- CloudWatch dashboards for application metrics
- CPU utilization alerts for auto-scaling
- Application health monitoring
- Database performance metrics
- Email notifications via SNS

## Assumptions Made

- Using AWS as cloud provider (easily adaptable to other providers)
- Single region deployment for simplicity
- PostgreSQL as database choice
- Email notifications for alerts (can be extended to Slack/PagerDuty)

## Known Limitations

- No HTTPS by default (requires SSL certificate)
- Single region deployment
- Basic monitoring setup (can be enhanced with custom metrics)
- No WAF or DDoS protection implemented

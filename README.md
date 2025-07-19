# DevOps Home Assessment

## 🚀 Overview
Simple Flask web app deployed with Terraform, Docker, and GitHub Actions on AWS.

## 📁 Folder Structure
<include tree>

## 🛠 Tools Used
- AWS (EC2, RDS, S3, IAM, Secrets Manager)
- Terraform
- GitHub Actions
- Docker

## ⚙️ Setup Instructions
1. Configure AWS credentials
2. Run Terraform
3. Push to GitHub to trigger CI/CD

## 🔐 Secrets
Stored in AWS Secrets Manager. Accessed by EC2 instance via IAM Role.

## 📊 Monitoring
- CloudWatch logs and metrics enabled
- Sample alarm: EC2 CPU > 80%

## 📌 Assumptions
- Region: us-east-1
- Public access via EC2 only

## 🧠 Reflection
- Used Fargate for scalability (decided to keep EC2 here for control in this example)
- Secrets via Secrets Manager instead of hardcoded env
- Used CloudWatch for simplicity over external tools

## ❗ Known Limitations
- No WAF or HTTPS setup (can be added as bonus)

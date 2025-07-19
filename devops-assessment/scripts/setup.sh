#!/bin/bash

set -e

echo "Setting up DevOps Assessment Infrastructure..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "Error: AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed. Please install Terraform first."
    exit 1
fi

BUCKET_NAME="test32co"
REGION="us-east-1"

if ! aws s3 ls "s3://$BUCKET_NAME" > /dev/null 2>&1; then
    echo "Creating S3 bucket for Terraform state..."
    aws s3 mb "s3://$BUCKET_NAME" --region $REGION
    aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
fi

# Initialize Terraform
echo "Initializing Terraform..."
cd terraform
terraform init

# Plan the infrastructure
echo "Planning Terraform deployment..."
terraform plan -var="alert_email=pkishore9391@gmail.com"

echo "Setup completed. Ready to deploy with 'terraform apply'"
echo "Don't forget to:"
echo "1. Update the S3 bucket name in terraform/main.tf"
echo "2. Set your alert email in terraform/variables.tf"
echo "3. Configure GitHub secrets for CI/CD pipeline"

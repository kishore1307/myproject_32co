#!/bin/bash

set -e

IMAGE_TAG=${1:-latest}
PROJECT_NAME="devops-assessment"
REGION="us-east-1"

echo "Starting deployment with image tag: $IMAGE_TAG"

# Update Launch Template with new image
aws ec2 create-launch-template-version \
    --launch-template-name "${PROJECT_NAME}-template" \
    --source-version '$Latest' \
    --launch-template-data "{\"ImageId\":\"ami-12345678\"}" \
    --region $REGION

# Get the latest version number
LATEST_VERSION=$(aws ec2 describe-launch-template-versions \
    --launch-template-name "${PROJECT_NAME}-template" \
    --query 'LaunchTemplateVersions[0].VersionNumber' \
    --output text \
    --region $REGION)

# Update Auto Scaling Group to use the new launch template version
aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "${PROJECT_NAME}-asg" \
    --launch-template LaunchTemplateName="${PROJECT_NAME}-template",Version=$LATEST_VERSION \
    --region $REGION

# Start instance refresh for rolling deployment
aws autoscaling start-instance-refresh \
    --auto-scaling-group-name "${PROJECT_NAME}-asg" \
    --preferences MinHealthyPercentage=50,InstanceWarmup=300 \
    --region $REGION

echo "Instance refresh started. Monitoring progress..."

# Monitor the instance refresh
while true; do
    STATUS=$(aws autoscaling describe-instance-refreshes \
        --auto-scaling-group-name "${PROJECT_NAME}-asg" \
        --query 'InstanceRefreshes[0].Status' \
        --output text \
        --region $REGION)
    
    echo "Instance refresh status: $STATUS"
    
    if [ "$STATUS" = "Successful" ]; then
        echo "Deployment completed successfully!"
        break
    elif [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ]; then
        echo "Deployment failed with status: $STATUS"
        exit 1
    fi
    
    sleep 30
done

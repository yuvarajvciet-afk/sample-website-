#!/bin/bash
set -e

AWS_REGION="ap-south-1"
ECR_REGISTRY_URI="123456789012.dkr.ecr.ap-south-1.amazonaws.com"
IMAGE_URI="$ECR_REGISTRY_URI/sample-website:latest"
CONTAINER_NAME="sample-website"

echo "Logging in to Amazon ECR"

aws ecr get-login-password --region "$AWS_REGION" |
docker login --username AWS --password-stdin "$ECR_REGISTRY_URI"

echo "Pulling the latest Docker image"

docker pull "$IMAGE_URI"

echo "Stopping old container if it exists"

docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

echo "Starting new container"

docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p 80:80 \
    "$IMAGE_URI"

echo "Deployment completed successfully"

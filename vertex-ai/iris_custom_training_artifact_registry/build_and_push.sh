#!/bin/bash

# Build and push Docker image for Vertex AI custom training
# This script fixes the region mismatch by using us-central1 instead of europe-west4

set -e

# Configuration
PROJECT_ID="gcp-network-452116"
REGION="us-central1"  # Fixed: using us-central1 instead of europe-west4
REPOSITORY="custom-training"
IMAGE_NAME="iris-custom-training"
IMAGE_TAG="latest"

# Construct the correct image URI for us-central1
IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building Docker image..."
echo "Image URI: ${IMAGE_URI}"

# Build the Docker image
docker build -t ${IMAGE_URI} .

echo "Pushing Docker image to Artifact Registry..."

# Configure Docker to use gcloud as a credential helper
gcloud auth configure-docker ${REGION}-docker.pkg.dev

# Push the image
docker push ${IMAGE_URI}

echo "Successfully pushed image: ${IMAGE_URI}"
echo "You can now use this image URI for Vertex AI custom training jobs."
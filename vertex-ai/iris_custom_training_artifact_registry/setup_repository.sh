#!/bin/bash

# Setup Artifact Registry repository for custom training
# This script creates the necessary repository if it doesn't exist

set -e

PROJECT_ID="gcp-network-452116"
REGION="us-central1"
REPOSITORY="custom-training"

echo "Setting up Artifact Registry repository..."
echo "Project: ${PROJECT_ID}"
echo "Region: ${REGION}"
echo "Repository: ${REPOSITORY}"

# Check if repository exists
if gcloud artifacts repositories describe ${REPOSITORY} --location=${REGION} --project=${PROJECT_ID} >/dev/null 2>&1; then
    echo "Repository ${REPOSITORY} already exists in ${REGION}"
else
    echo "Creating repository ${REPOSITORY} in ${REGION}..."
    gcloud artifacts repositories create ${REPOSITORY} \
        --repository-format=docker \
        --location=${REGION} \
        --project=${PROJECT_ID}
    echo "Repository created successfully"
fi

# Configure Docker authentication
echo "Configuring Docker authentication..."
gcloud auth configure-docker ${REGION}-docker.pkg.dev

echo "Setup complete! You can now run ./build_and_push.sh"
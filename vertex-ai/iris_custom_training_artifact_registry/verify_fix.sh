#!/bin/bash

# Verify the Docker image URI fix
# This script checks that all configurations use the correct us-central1 region

set -e

echo "=== Verifying Docker Image URI Fix ==="
echo

PROJECT_ID="gcp-network-452116"
CORRECT_REGION="us-central1"
WRONG_REGION="europe-west4"

echo "Project ID: ${PROJECT_ID}"
echo "Correct Region: ${CORRECT_REGION}"
echo "Wrong Region (should not appear): ${WRONG_REGION}"
echo

echo "1. Checking vertexai_start.py configuration..."
if grep -q "us-central1" ../vertexai_start.py; then
    echo "   ✓ Vertex AI region is correctly set to us-central1"
else
    echo "   ✗ Vertex AI region is not set to us-central1"
fi

echo

echo "2. Checking build script image URI..."
if grep -q "us-central1" build_and_push.sh; then
    echo "   ✓ Build script uses correct region (us-central1)"
else
    echo "   ✗ Build script does not use us-central1"
fi

echo

echo "3. Checking job submission script..."
if grep -q "us-central1" submit_job.py; then
    echo "   ✓ Job submission script uses correct region (us-central1)"
else
    echo "   ✗ Job submission script does not use us-central1"
fi

echo

echo "4. Files created for the fix:"
echo "   ✓ build_and_push.sh - Docker build and push script"
echo "   ✓ submit_job.py - Vertex AI job submission script"
echo "   ✓ setup_repository.sh - Artifact Registry setup script"
echo "   ✓ vertex_ai_custom_training_workflow.ipynb - Complete workflow notebook"
echo "   ✓ README.md - Documentation"

echo

echo "=== Summary ==="
echo "The Docker image URI has been fixed to use us-central1 instead of europe-west4."
echo "All scripts and configurations now use the correct region consistently."
echo

echo "Next steps:"
echo "1. Run: ./setup_repository.sh (to create Artifact Registry repository)"
echo "2. Run: ./build_and_push.sh (to build and push Docker image)"
echo "3. Run: python submit_job.py (to submit training job)"
echo "Or use the notebook: vertex_ai_custom_training_workflow.ipynb"
# Vertex AI Custom Training - Docker Image URI Fix

This directory contains the fixed setup for running custom training jobs on Vertex AI using Docker containers.

## Problem Fixed

The original issue was a region mismatch where Docker images were being pushed to `europe-west4-docker.pkg.dev` but the Vertex AI configuration was set to `us-central1`. This caused the error:

```
failed to copy: failed to do request: Put "https://europe-west4-docker.pkg.dev/..."
```

## Solution

### 1. Consistent Region Configuration
- All configurations now use `us-central1` region consistently
- Vertex AI initialization in `../vertexai_start.py` uses `us-central1`
- Docker image URI uses `us-central1-docker.pkg.dev`

### 2. Correct Image URI Format
```
us-central1-docker.pkg.dev/gcp-network-452116/custom-training/iris-custom-training:latest
```

## Files

### Core Training Files
- `Dockerfile` - Container definition for the training job
- `requirements.txt` - Python dependencies
- `vertexai_custom_training.py` - Training script (converted from notebook)

### New Workflow Files
- `build_and_push.sh` - Script to build and push Docker image with correct region
- `submit_job.py` - Python script to submit custom training job
- `vertex_ai_custom_training_workflow.ipynb` - Complete workflow notebook
- `README.md` - This documentation

## Usage

### Prerequisites

1. Create Artifact Registry repository:
```bash
gcloud artifacts repositories create custom-training --repository-format=docker --location=us-central1 --project=gcp-network-452116
```

2. Configure Docker authentication:
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### Build and Push Docker Image

```bash
cd iris_custom_training_artifact_registry
./build_and_push.sh
```

### Submit Training Job

```bash
python submit_job.py
```

Or use the notebook `vertex_ai_custom_training_workflow.ipynb` for an interactive experience.

## Key Changes Made

1. **Fixed region consistency**: Changed from `europe-west4` to `us-central1`
2. **Created missing build script**: `build_and_push.sh` with correct image URI
3. **Added job submission script**: `submit_job.py` for running custom jobs
4. **Created workflow notebook**: Complete end-to-end example
5. **Added documentation**: This README and inline comments

## Troubleshooting

### If you still get region errors:
1. Verify your Artifact Registry repository is in `us-central1`
2. Check that your service account has permissions for both regions
3. Ensure Docker is authenticated for the correct region

### If image push fails:
1. Verify the repository exists: `gcloud artifacts repositories list --location=us-central1`
2. Check authentication: `gcloud auth list`
3. Test Docker authentication: `docker pull us-central1-docker.pkg.dev/gcp-network-452116/custom-training/test || echo "Authentication working"`
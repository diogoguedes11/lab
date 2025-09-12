#!/usr/bin/env python3
"""
Submit Vertex AI Custom Training Job
This script submits a custom training job using the Docker image built with the correct region.
"""

import vertexai_start  # Initialize Vertex AI with correct project/region
from google.cloud import aiplatform
import os

def submit_custom_training_job():
    """Submit a custom training job to Vertex AI."""
    
    # Configuration
    PROJECT_ID = os.getenv("VERTEX_PROJECT_ID", "gcp-network-452116")
    REGION = os.getenv("VERTEX_REGION", "us-central1")  # Using us-central1, not europe-west4
    
    # Fixed image URI with correct region
    IMAGE_URI = f"{REGION}-docker.pkg.dev/{PROJECT_ID}/custom-training/iris-custom-training:latest"
    
    print(f"Project ID: {PROJECT_ID}")
    print(f"Region: {REGION}")
    print(f"Image URI: {IMAGE_URI}")
    
    # Create job display name
    JOB_NAME = "iris-custom-training-job"
    
    # Define the custom job
    job = aiplatform.CustomJob(
        display_name=JOB_NAME,
        worker_pool_specs=[
            {
                "machine_spec": {
                    "machine_type": "n1-standard-4",
                },
                "replica_count": 1,
                "container_spec": {
                    "image_uri": IMAGE_URI,
                },
            }
        ],
    )
    
    print(f"Submitting custom training job: {JOB_NAME}")
    print(f"Using image: {IMAGE_URI}")
    
    # Submit the job
    job.run(
        service_account=None,  # Use default service account
        timeout=3600,  # 1 hour timeout
        restart_job_on_user_error=False,
    )
    
    print(f"Job completed successfully!")
    print(f"Job resource name: {job.resource_name}")

if __name__ == "__main__":
    submit_custom_training_job()
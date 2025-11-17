#!/bin/bash

RESOURCE_GROUP_NAME="$1"
PASSWORD="$2"


# Set the resource group name (Ensure this variable is set correctly in your environment or script)
if [ -z "$RESOURCE_GROUP_NAME" ]; then
    echo "Usage: $0 <resource-group-name> <password>"
    exit 1
fi

if [ -z "$PASSWORD" ]; then
    echo "Usage: $0 <resource-group-name> <password>"
    exit 1
fi

az group create \
   --name "$RESOURCE_GROUP_NAME" \
   --location "eastus"

# Check if the resource group creation was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to create resource group"
    exit 1
fi

# Create two virtual machines

for i in 1 2; do
      az vm create \
         --resource-group "$RESOURCE_GROUP_NAME" \
         --name "my-test-vm-$i" \
         --image "Ubuntu2404" \
         --admin-username "admin" \
         --admin-password "$PASSWORD" \
         --size "Standard_D2s_v3" \
         --generate-ssh-keys
   
      # Check if the VM creation was successful
      if [ $? -ne 0 ]; then
         echo "Error: Failed to create VM my-test-vm-$i"
         exit 1
      fi
   done
   upgrade az cli
   
   To upgrade the Azure CLI on your system, run:
   
   If you are on WSL or Linux and need a manual upgrade, use:
   
   This will ensure you have the latest Azure CLI version.
   
   dard_DS1_v2' in a future release.
   The command failed with an unexpected error. Here is the traceback:
   The content for this response was already consumed
   Traceback (most recent call last):
   File "/opt/az/lib/python3.13/site-packages/azure/cli/core/commands/init.py", line 703, in _run_job
   result = cmd_copy(params)
   
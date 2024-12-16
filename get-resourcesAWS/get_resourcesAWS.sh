#!/bin/bash

# Set AWS Access Key and Secret Key
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="ap-southeast-1"

# Run the AWS CLI command to get resources
aws resourcegroupstaggingapi get-resources --region ap-southeast-1 --output json > PTG-Audit-Account.json

# Optional: Unset the credentials after use for security
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_DEFAULT_REGION

#!/bin/bash

credentials_file="aws_credentials.txt" 

counter=1  

cat "$credentials_file" | while IFS=: read -r access_key secret_key session_token; do
  
  export AWS_ACCESS_KEY_ID="$access_key"
  export AWS_SECRET_ACCESS_KEY="$secret_key"
  export AWS_SESSION_TOKEN="$session_token"
  export AWS_DEFAULT_REGION="ap-southeast-1"

  
  output_file="json${counter}.json"

  
  aws resourcegroupstaggingapi get-resources --region ap-southeast-1 --output json > "$output_file"

  
  counter=$((counter + 1))

  
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
done
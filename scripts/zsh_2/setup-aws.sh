#!/bin/bash

echo "Setting up AWS CLI configuration..."
echo "Please enter your AWS credentials when prompted."

# Prompt for AWS credentials
read -p "Enter your AWS Access Key ID: " aws_access_key
read -p "Enter your AWS Secret Access Key: " aws_secret_key
read -p "Enter your default region (e.g., us-east-1): " aws_region
read -p "Enter your output format (json/yaml/text): " aws_output

# Configure AWS CLI
aws configure set aws_access_key_id "$aws_access_key"
aws configure set aws_secret_access_key "$aws_secret_key"
aws configure set default.region "$aws_region"
aws configure set default.output "$aws_output"

echo "AWS CLI configuration completed!"
echo "You can verify your configuration by running: aws sts get-caller-identity" 
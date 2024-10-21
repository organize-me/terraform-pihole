#!/bin/bash

# Set Environment Variables for test the Terraform deployment
#
# Run this script as a . (dot) command to set the environment variables in the current shell. Example: ". ./env.sh"
# See the setup and teardown scripts for examples of how to use these environment variables.

export TF_VAR_backup_s3_bucket="pihole-test-bucket"
export TF_VAR_docker_network="pihole-test-network"

# Docker Desktop Daemon Socket
export TF_VAR_docker_host="unix://$HOME/.docker/desktop/docker.sock"

export AWS_ACCESS_KEY_ID="minioadmin"
export AWS_SECRET_ACCESS_KEY="minioadmin"
export AWS_S3_ENDPOINT_URL="http://host.docker.internal:9000"
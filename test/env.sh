#!/bin/bash

# Set Environment Variables for test the Terraform deployment
#
# Run this script as a . (dot) command to set the environment variables in the current shell. Example: ". ./env.sh"
# See the setup and teardown scripts for examples of how to use these environment variables.

# Set the aws-cli environment variables
export AWS_ACCESS_KEY_ID="minioadmin"
export AWS_SECRET_ACCESS_KEY="minioadmin"
export AWS_S3_ENDPOINT_URL="http://host.docker.internal:9000"

# Set the Terraform environment variables
export TF_VAR_backup_s3_bucket="pihole-test-bucket"
export TF_VAR_docker_network="pihole-test-network"
export TF_VAR_backup_archive_name="pihole-backup.tar.gz"
export TF_VAR_minio_root_user="$AWS_ACCESS_KEY_ID"
export TF_VAR_minio_root_password="$AWS_SECRET_ACCESS_KEY"

# Docker Desktop Daemon Socket
export TF_VAR_docker_host="unix://$HOME/.docker/desktop/docker.sock"

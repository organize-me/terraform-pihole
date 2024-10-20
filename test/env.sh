#!/bin/bash

# Set Environment Variables for test the Terraform deployment
#
# Run this script as a . (dot) command to set the environment variables in the current shell. Example: ". ./env.sh"
# See the setup and teardown scripts for examples of how to use these environment variables.

export TF_VAR_backup_install_path="../bin"
export TF_VAR_backup_s3_bucket="test-bucket"
export TF_VAR_docker_network="test"

# Docker Desktop Daemon Socket
export TF_VAR_docker_host="unix://$HOME/.docker/desktop/docker.sock"
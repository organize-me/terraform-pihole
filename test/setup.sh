#!/bin/bash

# Sets up the environment for testing the Terraform deployment

cd "$(dirname "$0")" || exit
. ./env.sh

if [ -z "${!$TF_VAR_docker_network}" ]; then
  echo 'Network variable not defined or is empty.'
  exit 1
fi

# create the test network
if ! docker network ls | grep -q "$TF_VAR_docker_network"; then
  echo "Creating Network: $TF_VAR_docker_network"
  docker network create "$TF_VAR_docker_network"
fi

docker compose -f docker-compose.yml up -d

# Wait for MinIO to start
sleep 5

# Create default bucket
docker exec -it minio /bin/sh -c "
  mc alias set myminio http://localhost:9000 $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY &&
  mc mb myminio/$TF_VAR_backup_s3_bucket
"

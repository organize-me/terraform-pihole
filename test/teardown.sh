#!/bin/bash

# Tears down the environment for testing the Terraform deployment

cd "$(dirname "$0")" || exit
. ./env.sh

docker compose -f docker-compose.yml down

if [ -z "${!$TF_VAR_docker_network}" ]; then
  echo 'Network variable not defined or is empty.'
  exit 1
fi

# delete the test network
if docker network ls | grep -q "$TF_VAR_docker_network"; then
  echo "Destroying Network: $TF_VAR_docker_network"
  docker network rm "$TF_VAR_docker_network"
fi

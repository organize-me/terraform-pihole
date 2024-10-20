#!/bin/bash

# Sets up the environment for testing the Terraform deployment

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
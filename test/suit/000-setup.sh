#!/bin/bash

echo "Setup Test Environment"

cd "$(dirname "$0")" || exit 1
. ../env.sh

cd ../terraform || exit 1
terraform init -upgrade || exit 1
terraform apply -auto-approve || exit 1

echo "Test Environment Setup Successful"
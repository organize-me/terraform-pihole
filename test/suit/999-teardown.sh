#!/bin/bash

echo "Teardown Test Environment"

cd "$(dirname "$0")" || exit
. ../env.sh

cd ../terraform || exit
terraform init -upgrade
terraform destroy -auto-approve

echo "Successful test environment teardown"
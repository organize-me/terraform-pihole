#!/bin/bash

echo "Uninstall Pi-hole"

cd "$(dirname "$0")" || exit 1
. ../env.sh

# project root
cd ../.. || exit 1

# main terraform directory
cd ./terraform || exit 1

terraform init -upgrade || exit 1
terraform destroy -auto-approve || exit 1

echo "Successfully uninstalled pi-hole"

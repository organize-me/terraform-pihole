#!/bin/bash

echo "Run Backup Process"

cd "$(dirname "$0")" || exit 1
. ../env.sh

PATH="$PATH:../../bin" || exit 1

pihole-backup.sh || exit 1

echo "Backup Successful"

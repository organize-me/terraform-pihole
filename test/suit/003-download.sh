#!/bin/bash

echo "Run Download Process"

cd "$(dirname "$0")" || exit 1
. ../env.sh

if [ -z "$TF_VAR_backup_archive_name" ]; then
  echo "TF_VAR_backup_archive_name is not set"
  exit 1
fi

PATH="$PATH:../../bin" || exit 1

pihole-download.sh || exit 1

if [ -f "$TF_VAR_backup_archive_name" ]; then
  echo "Downloaded Successful"
else
  echo "Failed to download pi-hole backup"
  exit 1
fi

rm -f "$TF_VAR_backup_archive_name"

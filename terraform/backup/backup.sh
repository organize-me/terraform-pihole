#!/bin/sh

echo "Backing Up Pi-hole Data"

export TEMP_DIR=/tmp/backup

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Archive Pi-hole data
cd "${TF_VOLUME_DIR}" || exit 1
zip -r "$TEMP_DIR/${TF_ARCHIVE_NAME}" pihole_config pihole_dnsmasq

# Upload to S3
cd "$TEMP_DIR" || exit 1
aws s3 cp "$TEMP_DIR" "s3://${TF_S3_BACKUP_BUCKET}/${TF_ARCHIVE_NAME}" || exit 1

# Clean up
rm -rf "$TEMP_DIR"

#!/bin/sh

# Backup Script
# Runs the backup process for pi-hole

docker run \
  --rm \
  --name "pihole_backup" \
  --env "AWS_TOKEN=$${AWS_TOKEN}" \
  --env "AWS_SECRET=$${AWS_SECRET}" \
  --volume "${TF_VOLUME_PIHOLE_CONFIG}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_CONFIG}" \
  --volume "${TF_VOLUME_PIHOLE_DNSMASQ}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_DNSMASQ}" \
  "${TF_IMAGE_NAME}" \
  "backup"

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Backup Failed"
fi

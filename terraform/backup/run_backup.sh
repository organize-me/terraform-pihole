#!/bin/sh

# Backup Script
# Runs the backup process for pi-hole

START_TIME=$(date +%s)

docker run \
  --rm \
  --name "pihole_backup" \
  --env "AWS_ACCESS_KEY_ID=$${AWS_ACCESS_KEY_ID}" \
  --env "AWS_SECRET_ACCESS_KEY=$${AWS_SECRET_ACCESS_KEY}" \
  --env "AWS_DEFAULT_REGION=$${AWS_DEFAULT_REGION}" \
  --volume "$HOME/.aws:/root/.aws:ro" \
  --volume "${TF_VOLUME_PIHOLE_CONFIG}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_CONFIG}:ro" \
  --volume "${TF_VOLUME_PIHOLE_DNSMASQ}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_DNSMASQ}:ro" \
  "${TF_IMAGE_NAME}" \
  "backup"

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Backup Failed"
fi

ELAPSED_TIME=$(($(date +%s) - $START_TIME))
echo "Execution time: $ELAPSED_TIME seconds"

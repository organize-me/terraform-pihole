#!/bin/sh

# Restore Script
# Runs the restore process for pi-hole

docker run \
  --rm \
  --name "pihole_restore" \
  --env "AWS_TOKEN=$${AWS_TOKEN}" \
  --env "AWS_SECRET=$${AWS_SECRET}" \
  --volume "${TF_VOLUME_PIHOLE_CONFIG}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_CONFIG}" \
  --volume "${TF_VOLUME_PIHOLE_DNSMASQ}:${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_DNSMASQ}" \
  ${TF_IMAGE_NAME} \
  "restore"

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Restore Failed"
fi

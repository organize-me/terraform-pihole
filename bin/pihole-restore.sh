#!/bin/sh

# Restore Script
# Runs the restore process for pi-hole

docker run \
  --rm \
  --name "pihole_restore" \
  --env "AWS_TOKEN=${AWS_TOKEN}" \
  --env "AWS_SECRET=${AWS_SECRET}" \
  --volume "pihole_config:/mnt/backup/volumes/pihole_config" \
  --volume "pihole_dnsmasq:/mnt/backup/volumes/pihole_dnsmasq" \
  organize_me_pihole_backup \
  "restore"

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Restore Failed"
fi

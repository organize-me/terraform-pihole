#!/bin/sh

# Backup Script
# Runs the backup process for pi-hole

START_TIME=$(date +%s)

WORKDIR = $HOME/.backup-pihole

mkdir -p $WORKDIR

docker exec "${TF_PIHOLE_CONTAINER}" mkdir -p /tmp/backup && /usr/local/bin/pihole -a -t /tmp/backup/pihole-backup.tar.gz
docker cp "${TF_PIHOLE_CONTAINER}:/tmp/backup/pihole-backup.tar.gz" $WORKDIR/pihole-backup.tar.gz
docker exec "${TF_PIHOLE_CONTAINER}" rm -rf /tmp/backup

ARGS="--rm"
ARGS="$ARGS --name=pihole_backup"
ARGS="$ARGS --volume=$WORKDIR:/tmp/.backup-pihole"

# AWS Directory
if [ -d "$HOME/.aws" ]; then
  ARGS="$ARGS --volume=$HOME/.aws:/root/.aws:ro"
fi

# AWS DEFAULT REGION
if [ -n "$AWS_DEFAULT_REGION" ]; then
  ARGS="$ARGS --env \"AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION\""
fi

# AWS ACCESS KEY ID
if [ -n "$AWS_ACCESS_KEY_ID" ]; then
  ARGS="$ARGS --env \"AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID\""
fi

# AWS SECRET ACCESS KEY
if [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  ARGS="$ARGS --env \"AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY\""
fi

docker run $ARGS "${TF_IMAGE_NAME}" "backup"

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  echo "Backup Failed"
fi

rm -rf $WORKDIR

ELAPSED_TIME=$(($(date +%s) - $START_TIME))
echo "Execution time: $ELAPSED_TIME seconds"

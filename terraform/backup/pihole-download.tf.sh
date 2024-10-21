#!/bin/sh

# Download the backup archive from S3

TEMP_DIR_AWSCLI="/tmp/backup"

set -- "--rm"
set -- "$@" "--name" "pihole_backup"
set -- "$@" "--volume" "$PWD:$TEMP_DIR_AWSCLI"

# AWS Directory (if exists)
if [ -d "$HOME/.aws" ]; then
  set -- "$@" "--volume" "$HOME/.aws:/root/.aws:ro"
fi

# AWS DEFAULT REGION (if exists)
if [ -n "$AWS_DEFAULT_REGION" ]; then
  set -- "$@" "--env" "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
fi

# AWS ACCESS KEY ID (if exists)
if [ -n "$AWS_ACCESS_KEY_ID" ]; then
  set -- "$@" "--env" "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
fi

# AWS SECRET ACCESS KEY (if exists)
if [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  set -- "$@" "--env" "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
fi

CMD="s3"
[ -n "$AWS_S3_ENDPOINT_URL" ] && CMD="s3 --endpoint-url $AWS_S3_ENDPOINT_URL"
CMD="$CMD cp s3://${TF_S3_BACKUP_BUCKET}/${TF_ARCHIVE_NAME} $TEMP_DIR_AWSCLI/${TF_ARCHIVE_NAME}"

docker run "$@" "${TF_AWS_CLI_IMAGE}" $CMD || halt 1 "Unable to download backup archive from S3"
#!/bin/sh

# Backup Script
# Runs the backup process for pi-hole

TEMP_DIR_HOST="${TF_BACKUP_TMP_DIR}"
TEMP_DIR_PIHOLE="/tmp/backup"
TEMP_DIR_AWSCLI="/tmp/backup"

# Clean up
cleanup () {
  echo "Cleanup Start"

  # Delete the temporary directory
  if [ -d "$TEMP_DIR_HOST" ]; then
    rm -rf "$TEMP_DIR_HOST"
  fi

  echo "Cleanup Complete"
}

# Halt the script
halt () {
  # $1 - Exit code (optional)
  # $2 - Message (optional)

  if [ -n "$1" ]; then
    EXIT_CODE=$1
  else
    EXIT_CODE=0
  fi

  cleanup

  # Exit
  if [ $EXIT_CODE -ne 0 ]; then
    if [ -n "$2" ]; then
      echo "Backup Failed: $2"
    else
      echo "Backup Failed"
    fi
  fi
  exit $EXIT_CODE
}

# Archive Pi-hole data
archive_pi_hole_data () {
  # Archive Pi-hole data
  echo "Archive Start"

  mkdir -p "$TEMP_DIR_HOST" || halt 1 "001 : Unable to create temporary directory"

  # Extract Pi-hole data
  docker exec "${TF_PIHOLE_CONTAINER}" mkdir -p $TEMP_DIR_PIHOLE || halt 1 "002 : Unable to create temporary directory"
  docker exec "${TF_PIHOLE_CONTAINER}" /usr/local/bin/pihole -a -t "$TEMP_DIR_PIHOLE/${TF_ARCHIVE_NAME}" || halt 1 "003 : Unable to create backup archive"
  docker cp "${TF_PIHOLE_CONTAINER}:$TEMP_DIR_PIHOLE/${TF_ARCHIVE_NAME}" "$TEMP_DIR_HOST/${TF_ARCHIVE_NAME}" || halt 1 "004 : Unable to copy backup archive to host"
  docker exec "${TF_PIHOLE_CONTAINER}" rm -rf $TEMP_DIR_PIHOLE || halt 1 "005 : Unable to remove temporary directory"

  echo "Archive Complete"
}

# Upload to S3
upload_archive_to_s3 () {
  # Upload to S3
  echo "Upload Start"

  set -- "--rm"
  set -- "$@" "--name" "pihole_backup"
  set -- "$@" "--volume" "$TEMP_DIR_HOST:$TEMP_DIR_AWSCLI"

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


  CMD="s3 cp $TEMP_DIR_AWSCLI/${TF_ARCHIVE_NAME} s3://${TF_S3_BACKUP_BUCKET}/${TF_ARCHIVE_NAME}"
  docker run "$@" "${TF_AWS_CLI_IMAGE}" $CMD || halt 1 "006 : Unable to upload backup archive to S3"

  echo "Upload Complete"
}

# Run the backup process
run () {
  archive_pi_hole_data
  upload_archive_to_s3
  cleanup
}

# Capture start time
START_TIME=$(date +%s)

# Ensure elapsed time is displayed on exit
trap 'ELAPSED_TIME=$(($(date +%s) - $START_TIME)); echo "Execution time: $ELAPSED_TIME seconds"' EXIT

# Run the backup process
run

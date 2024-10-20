locals {
  backup_volumes_path = "/mnt/backup/volumes"
  backup_archive_name  = "pihole-backup.zip"
}

# Script to backup the pi-hole configuration from the Docker container
resource "local_file" "backup_script" {
  filename = "../backup/backup.sh"
  content  = templatefile("./backup/backup.sh", {
    TF_VOLUME_DIR       = local.backup_volumes_path
    TF_ARCHIVE_NAME     = local.backup_archive_name
    TF_S3_BACKUP_BUCKET = var.backup_s3_bucket
  })
}

# Script to restore the pi-hole configuration from the Docker container
resource "local_file" "restore_script" {
  filename = "../backup/restore.sh"
  content  = templatefile("./backup/restore.sh", {
    TF_VOLUME_DIR       = local.backup_volumes_path
    TF_ARCHIVE_NAME     = local.backup_archive_name
    TF_S3_BACKUP_BUCKET = var.backup_s3_bucket
  })
}

# Dockerfile for the backup image
resource "local_file" "dockerfile_backup" {
  filename = "../backup/Dockerfile"
  content  = templatefile("./backup/Dockerfile", {
    TF_VOLUME_DIR            = local.backup_volumes_path
    TF_VOLUME_PIHOLE_CONFIG  = docker_volume.pihole_config.name
    TF_VOLUME_PIHOLE_DNSMASQ = docker_volume.pihole_dnsmasq.name
    TF_ARCHIVE_NAME          = local.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
  })
}

# Builds the docker image for the backup/restore processes
resource "docker_image" "backup" {
  name = "organize_me_pihole_backup"
  build {
    context = "../backup"
  }
  triggers = {
    DOCKERFILE     = local_file.dockerfile_backup.content_md5
    BACKUP_SCRIPT  = local_file.backup_script.content_md5
    RESTORE_SCRIPT = local_file.restore_script.content_md5
  }

  depends_on = [local_file.dockerfile_backup, local_file.backup_script, local_file.backup_script]
}

# Script to run the backup script as a Docker container
resource "local_file" "run_backup" {
  filename = "${var.backup_install_path}/pihole-backup.sh"
  content = templatefile("./backup/run_backup.sh", {
    TF_VOLUME_DIR            = local.backup_volumes_path
    TF_VOLUME_PIHOLE_CONFIG  = docker_volume.pihole_config.name
    TF_VOLUME_PIHOLE_DNSMASQ = docker_volume.pihole_dnsmasq.name
    TF_ARCHIVE_NAME          = local.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_IMAGE_NAME            = docker_image.backup.name
  })
}

# Make the backup script executable
resource "null_resource" "run_backup_exec" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.run_backup.filename}"
  }

  triggers = {
    md5 = local_file.run_backup.content_md5
  }

  depends_on = [local_file.run_backup]
}

# Script to run the restore script as a Docker container
resource "local_file" "run_restore" {
  filename = "${var.backup_install_path}/pihole-restore.sh"
  content = templatefile("./backup/run_restore.sh", {
    TF_VOLUME_DIR            = local.backup_volumes_path
    TF_VOLUME_PIHOLE_CONFIG  = docker_volume.pihole_config.name
    TF_VOLUME_PIHOLE_DNSMASQ = docker_volume.pihole_dnsmasq.name
    TF_ARCHIVE_NAME          = local.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_IMAGE_NAME            = docker_image.backup.name
  })
}

# Make the restore script executable
resource "null_resource" "run_restore_exec" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.run_restore.filename}"
  }

  triggers = {
    md5 = local_file.run_restore.content_md5
  }

  depends_on = [local_file.run_restore]
}